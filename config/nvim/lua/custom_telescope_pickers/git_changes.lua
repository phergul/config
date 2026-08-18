local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local conf = require('telescope.config').values
local entry_display = require 'telescope.pickers.entry_display'
local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local previewers = require 'telescope.previewers'
local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
local icons = require 'config.icons'

local M = {}

local ns = vim.api.nvim_create_namespace 'telescope_git_changes'

local status_priority = {
  S = 1,
  M = 2,
  A = 3,
}

local function split_output(text)
  if not text or text == '' then
    return {}
  end

  return vim.split(text:gsub('\n$', ''), '\n', { plain = true, trimempty = false })
end

local function run_git(args, opts)
  return vim
    .system(vim.list_extend({ 'git' }, args), {
      cwd = opts and opts.cwd,
      text = true,
    })
    :wait()
end

local function git_lines(args, opts)
  local result = run_git(args, opts)
  if result.code ~= 0 then
    return {}
  end

  return split_output(result.stdout)
end

local function get_hl(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok then
    return hl
  end
  return {}
end

local function first_hl_color(groups, key, fallback)
  for _, group in ipairs(groups) do
    local value = get_hl(group)[key]
    if value then
      return value
    end
  end

  return fallback
end

local function rgb(color)
  return math.floor(color / 0x10000) % 0x100, math.floor(color / 0x100) % 0x100, color % 0x100
end

local function to_hex(color)
  return string.format('#%06x', color)
end

local function blend(fg, bg, alpha)
  local fr, fg_g, fb = rgb(fg)
  local br, bg_g, bb = rgb(bg)

  local function mix(a, b)
    return math.floor((alpha * a) + ((1 - alpha) * b) + 0.5)
  end

  return string.format('#%02x%02x%02x', mix(fr, br), mix(fg_g, bg_g), mix(fb, bb))
end

local function setup_highlights()
  local normal_fg = first_hl_color({ 'NormalFloat', 'Normal' }, 'fg', 0xCDD6F4)
  local normal_bg = first_hl_color({ 'NormalFloat', 'Normal' }, 'bg', 0x1E1E2E)
  local dir_fg = first_hl_color({ 'Comment', 'NonText' }, 'fg', 0x7F849C)
  local added_fg = first_hl_color({ 'GitSignsAdd', 'DiffAdd', 'Added' }, 'fg', 0xA6D189)
  local modified_fg = first_hl_color({ 'GitSignsChange', 'DiffChange', 'DiffText' }, 'fg', 0xE5C890)
  local deleted_fg = first_hl_color({ 'GitSignsDelete', 'DiffDelete', 'Removed' }, 'fg', 0xE78284)
  local staged_fg = first_hl_color({ 'DiagnosticInfo', 'DiffText', 'Function' }, 'fg', 0x8CAAEE)

  vim.api.nvim_set_hl(0, 'TelescopeGitModified', { fg = to_hex(modified_fg), bold = true })
  vim.api.nvim_set_hl(0, 'TelescopeGitAdded', { fg = to_hex(added_fg), bold = true })
  vim.api.nvim_set_hl(0, 'TelescopeGitRemoved', { fg = to_hex(deleted_fg), bold = true })
  vim.api.nvim_set_hl(0, 'TelescopeGitStaged', { fg = to_hex(staged_fg), bold = true })

  vim.api.nvim_set_hl(0, 'TelescopeGitDir', { fg = to_hex(dir_fg) })
  vim.api.nvim_set_hl(0, 'TelescopeGitFile', { fg = to_hex(normal_fg), bold = true })

  vim.api.nvim_set_hl(0, 'TelescopeGitHunkHeader', {
    fg = to_hex(modified_fg),
    bg = blend(modified_fg, normal_bg, 0.14),
    bold = true,
  })
  vim.api.nvim_set_hl(0, 'TelescopeGitDiffMeta', { fg = to_hex(dir_fg) })
  vim.api.nvim_set_hl(0, 'TelescopeGitPreviewAddLine', { bg = blend(added_fg, normal_bg, 0.12) })
  vim.api.nvim_set_hl(0, 'TelescopeGitPreviewDeleteLine', { bg = blend(deleted_fg, normal_bg, 0.12) })
  vim.api.nvim_set_hl(0, 'TelescopeGitPreviewDeleteAccent', {
    fg = to_hex(deleted_fg),
    bg = blend(deleted_fg, normal_bg, 0.12),
    bold = true,
  })
  vim.api.nvim_set_hl(0, 'TelescopeGitPreviewDeleteVirtual', {
    fg = to_hex(deleted_fg),
    bg = blend(deleted_fg, normal_bg, 0.12),
  })
end

local function get_git_root()
  local out = git_lines { 'rev-parse', '--show-toplevel' }
  return out[1]
end

local function split_path(path)
  local dir = vim.fn.fnamemodify(path, ':h')
  local file = vim.fn.fnamemodify(path, ':t')

  if dir == '.' then
    dir = ''
  end

  return dir, file
end

local function shorten_path(dir, max_len)
  if dir == '' then
    return ''
  end

  max_len = max_len or 36

  if #dir <= max_len then
    return dir .. '/'
  end

  local parts = vim.split(dir, '/', { plain = true })
  if #parts <= 2 then
    return dir .. '/'
  end

  local shortened = {}
  for i = 1, #parts - 1 do
    shortened[i] = parts[i]:sub(1, 1)
  end
  shortened[#parts] = parts[#parts]

  local candidate = table.concat(shortened, '/')
  if #candidate > max_len then
    candidate = icons.ui.ellipsis .. '/' .. table.concat({ parts[#parts - 1], parts[#parts] }, '/')
  end

  return candidate .. '/'
end

local function get_file_icon(filename, path)
  if has_devicons then
    local icon, icon_hl = devicons.get_icon(filename, vim.fn.fnamemodify(path, ':e'), { default = true })
    return icon or icons.files.default, icon_hl or 'TelescopeGitFile'
  end

  return icons.files.default, 'TelescopeGitFile'
end

local function make_item(path, kind, staged)
  local dir, file = split_path(path)
  local file_icon, file_icon_hl = get_file_icon(file, path)

  local spec = {
    staged = {
      status = 'S',
      icon = icons.git_changes.staged,
      hl = 'TelescopeGitStaged',
      source = 'index',
    },
    modified = {
      status = 'M',
      icon = icons.git_changes.modified,
      hl = 'TelescopeGitModified',
      source = 'worktree',
    },
    added = {
      status = 'A',
      icon = icons.git_changes.added,
      hl = 'TelescopeGitAdded',
      source = 'worktree',
    },
    untracked = {
      status = 'A',
      icon = icons.git_changes.added,
      hl = 'TelescopeGitAdded',
      source = 'untracked',
    },
  }

  local item = spec[kind]
  if not item then
    return nil
  end

  return {
    path = path,
    dir = dir,
    dir_short = shorten_path(dir, 36),
    file = file,
    file_icon = file_icon,
    file_icon_hl = file_icon_hl,
    kind = kind,
    staged = staged,
    status = item.status,
    icon = item.icon,
    hl = item.hl,
    source = item.source,
    ordinal = table.concat({
      item.status,
      path,
      file,
      dir,
      kind,
      item.source,
    }, ' '),
  }
end

local function status_items_from_xy(xy, path)
  local x = xy:sub(1, 1)
  local y = xy:sub(2, 2)
  local items = {}

  if xy == '??' then
    table.insert(items, make_item(path, 'untracked', false))
    return items
  end

  if x == 'A' or x == 'M' or x == 'R' or x == 'C' then
    table.insert(items, make_item(path, 'staged', true))
  end

  if y == 'M' then
    table.insert(items, make_item(path, 'modified', false))
  elseif y == 'A' then
    table.insert(items, make_item(path, 'added', false))
  end

  return vim.tbl_filter(function(item)
    return item ~= nil
  end, items)
end

local function get_git_status(git_root)
  local output = git_lines({ 'status', '--porcelain=v1', '--untracked-files=all' }, { cwd = git_root })
  local items = {}

  for _, line in ipairs(output) do
    if line ~= '' then
      local xy = line:sub(1, 2)
      local path = line:sub(4)

      local renamed_to = path:match '->%s*(.+)$'
      if renamed_to then
        path = renamed_to
      end

      for _, item in ipairs(status_items_from_xy(xy, path)) do
        item.absolute_path = vim.fs.joinpath(git_root, item.path)
        table.insert(items, item)
      end
    end
  end

  table.sort(items, function(a, b)
    if status_priority[a.status] ~= status_priority[b.status] then
      return status_priority[a.status] < status_priority[b.status]
    end

    if a.path ~= b.path then
      return a.path < b.path
    end

    return a.source < b.source
  end)

  return items
end

local function read_file_lines(path)
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end

  return lines
end

local function make_new_file_diff(item, file_lines)
  local line_count = #file_lines
  local start = line_count == 0 and 0 or 1
  local lines = {
    string.format('diff --git a/%s b/%s', item.path, item.path),
    'new file mode 100644',
    '--- /dev/null',
    '+++ b/' .. item.path,
    string.format('@@ -0,0 +%d,%d @@', start, line_count),
  }

  for _, line in ipairs(file_lines) do
    table.insert(lines, '+' .. line)
  end

  return lines
end

local function get_diff_lines(git_root, item)
  local args = { 'diff', '--no-ext-diff', '--unified=3' }
  if item.staged then
    table.insert(args, '--cached')
  end
  vim.list_extend(args, { '--', item.path })

  local lines = git_lines(args, { cwd = git_root })
  if not vim.tbl_isempty(lines) then
    return lines
  end

  if item.kind == 'untracked' or item.kind == 'added' then
    local file_lines = read_file_lines(vim.fs.joinpath(git_root, item.path)) or {}
    return make_new_file_diff(item, file_lines)
  end

  return lines
end

local function summarize_diff(lines)
  local added = 0
  local removed = 0

  for _, line in ipairs(lines) do
    if vim.startswith(line, '+') and not vim.startswith(line, '+++') then
      added = added + 1
    elseif vim.startswith(line, '-') and not vim.startswith(line, '---') then
      removed = removed + 1
    end
  end

  return added, removed
end

local function filter_preview_lines(lines)
  if vim.tbl_isempty(lines) then
    return lines
  end

  local preview_lines = {}

  for _, line in ipairs(lines) do
    if
      vim.startswith(line, '@@')
      or (vim.startswith(line, '+') and not vim.startswith(line, '+++'))
      or (vim.startswith(line, '-') and not vim.startswith(line, '---'))
      or vim.startswith(line, ' ')
      or line == '\\ No newline at end of file'
    then
      table.insert(preview_lines, line)
    end
  end

  return preview_lines
end

local function reset_buffer_highlighting(bufnr)
  pcall(vim.treesitter.stop, bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  vim.bo[bufnr].filetype = ''
  pcall(vim.api.nvim_set_option_value, 'syntax', '', { buf = bufnr })
end

local function set_preview_buffer(bufnr, lines, filetype)
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modifiable = false

  if filetype and filetype ~= '' then
    vim.bo[bufnr].filetype = filetype
    pcall(vim.api.nvim_set_option_value, 'syntax', filetype, { buf = bufnr })
  end
end

local function highlight_line(bufnr, row, text, hl_group)
  vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
    end_row = row,
    end_col = math.max(#text, 1),
    hl_group = hl_group,
    hl_mode = 'combine',
    hl_eol = true,
    strict = false,
  })
end

local function clamp(value, min_value, max_value)
  return math.max(min_value, math.min(value, max_value))
end

local function diff_line_group(line)
  if vim.startswith(line, '@@') then
    return 'TelescopeGitHunkHeader'
  end

  if
    vim.startswith(line, 'diff --git')
    or vim.startswith(line, 'index ')
    or vim.startswith(line, '--- ')
    or vim.startswith(line, '+++ ')
    or vim.startswith(line, 'new file mode')
  then
    return 'TelescopeGitDiffMeta'
  end

  if vim.startswith(line, '+') and not vim.startswith(line, '+++') then
    return 'TelescopeGitPreviewAddLine'
  end

  if vim.startswith(line, '-') and not vim.startswith(line, '---') then
    return 'TelescopeGitPreviewDeleteLine'
  end
end

local function decorate_diff_preview(bufnr, lines)
  local first_change = nil

  for i, line in ipairs(lines) do
    local hl = diff_line_group(line)
    if hl then
      highlight_line(bufnr, i - 1, line, hl)
      if first_change == nil and vim.startswith(line, '@@') then
        first_change = i
      end
    end
  end

  return first_change or 1
end

local function build_preview(git_root, item)
  local diff_lines = item.diff_lines or get_diff_lines(git_root, item)
  local lines = vim.tbl_isempty(diff_lines) and { 'No diff available.' } or filter_preview_lines(diff_lines)
  if vim.tbl_isempty(lines) then
    lines = { 'No diff available.' }
  end

  return {
    lines = lines,
    filetype = 'diff',
    decorate = function(bufnr)
      return decorate_diff_preview(bufnr, lines)
    end,
  }
end

local function render_preview(bufnr, winid, git_root, item)
  local preview = build_preview(git_root, item)

  reset_buffer_highlighting(bufnr)
  set_preview_buffer(bufnr, preview.lines, preview.filetype)

  local focus_line = preview.decorate(bufnr)
  if winid and vim.api.nvim_win_is_valid(winid) then
    vim.wo[winid].wrap = false
    local max_line = math.max(vim.api.nvim_buf_line_count(bufnr), 1)
    pcall(vim.api.nvim_win_set_cursor, winid, { clamp(focus_line, 1, max_line), 0 })
  end
end

local function make_previewer(git_root)
  return previewers.new_buffer_previewer {
    title = 'Git Preview',
    dyn_title = function(_, entry)
      local item = entry.value
      return string.format('%s [hunks, %s]', item.path, item.source)
    end,
    define_preview = function(self, entry)
      if not entry or not entry.value then
        return
      end

      render_preview(self.state.bufnr, self.state.winid, git_root, entry.value)
    end,
  }
end

function M.git_changes()
  local git_root = get_git_root()
  if not git_root then
    vim.notify('Not inside a git repository', vim.log.levels.WARN)
    return
  end

  setup_highlights()

  local results = get_git_status(git_root)
  if vim.tbl_isempty(results) then
    vim.notify('No modified, staged, or untracked files', vim.log.levels.INFO)
    return
  end

  local status_width = 2
  local icon_width = 2
  local dir_width = 28
  local file_indent_width = 1
  local file_icon_width = 2
  local spacer_width = 2
  local stat_width = 6
  local separator_width = 1
  local total_fixed_width = status_width
    + icon_width
    + dir_width
    + file_indent_width
    + file_icon_width
    + spacer_width
    + stat_width
    + stat_width
  local total_separator_width = separator_width * 7

  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = status_width },
      { width = icon_width },
      { width = dir_width },
      { width = file_indent_width },
      { width = file_icon_width },
      {
        width = function(_, cols)
          return math.max(cols - total_fixed_width - total_separator_width, 8)
        end,
      },
      { width = spacer_width },
      { width = stat_width, right_justify = true },
      { width = stat_width, right_justify = true },
    },
  }

  local function make_display(entry)
    local item = entry.value

    return displayer {
      { item.status, item.hl },
      { item.icon, item.hl },
      { item.dir_short, 'TelescopeGitDir' },
      { '', 'TelescopeGitDiffMeta' },
      { item.file_icon, item.file_icon_hl },
      { item.file, 'TelescopeGitFile' },
      { '', 'TelescopeGitDiffMeta' },
      { item.added_text, 'TelescopeGitAdded' },
      { item.removed_text, 'TelescopeGitRemoved' },
    }
  end

  pickers
    .new({}, {
      prompt_title = 'Git Changes',
      results_title = 'Index / Worktree',
      dynamic_preview_title = true,
      layout_strategy = 'horizontal',
      layout_config = {
        preview_width = 0.5,
      },
      finder = finders.new_table {
        results = results,
        entry_maker = function(item)
          local diff_lines = get_diff_lines(git_root, item)
          local added_count, removed_count = summarize_diff(diff_lines)
          local value = vim.tbl_extend('force', item, {
            diff_lines = diff_lines,
            added_count = added_count,
            removed_count = removed_count,
            added_text = string.format('+%d', added_count),
            removed_text = string.format('-%d', removed_count),
          })
          value.ordinal = table.concat({
            value.ordinal,
            value.added_text,
            value.removed_text,
          }, ' ')

          return {
            value = value,
            ordinal = value.ordinal,
            display = make_display,
            path = value.absolute_path,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = make_previewer(git_root),
      attach_mappings = function(prompt_bufnr, map)
        local function selection()
          return action_state.get_selected_entry()
        end

        local function edit(cmd)
          local sel = selection()
          if not sel then
            return
          end

          actions.close(prompt_bufnr)
          vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(sel.value.absolute_path))
        end

        actions.select_default:replace(function()
          edit 'edit'
        end)

        map('i', '<C-v>', function()
          edit 'vsplit'
        end)
        map('n', '<C-v>', function()
          edit 'vsplit'
        end)

        map('i', '<C-s>', function()
          edit 'split'
        end)
        map('n', '<C-s>', function()
          edit 'split'
        end)

        return true
      end,
    })
    :find()
end

function M.setup()
  setup_highlights()

  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = setup_highlights,
  })
end

return M
