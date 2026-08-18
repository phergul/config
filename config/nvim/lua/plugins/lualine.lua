return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    local icons = require 'config.icons'
    local modes = { 'normal', 'insert', 'visual', 'replace', 'command' }

    local function to_hex(value)
      if not value then
        return nil
      end

      if type(value) == 'string' then
        if value:match '^#%x%x%x%x%x%x$' then
          return value
        end
        return nil
      end

      if type(value) == 'number' then
        return string.format('#%06x', value)
      end

      return nil
    end

    local function first_hl_color(groups, key)
      for _, group in ipairs(groups) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        local value = ok and hl and hl[key] or nil
        if value then
          return to_hex(value)
        end
      end

      return nil
    end

    local function flatten_theme(theme, fg, bg)
      if not fg or not bg then
        return theme
      end

      local out = vim.deepcopy(theme)
      for _, sections in pairs(out) do
        if type(sections) == 'table' then
          for _, colors in pairs(sections) do
            if type(colors) == 'table' then
              colors.fg = fg
              colors.bg = bg
            end
          end
        end
      end

      return out
    end

    local function current_mode_key()
      local mode = vim.api.nvim_get_mode().mode
      if mode:match '^[vV\22]' then
        return 'visual'
      end
      if mode:match '^i' then
        return 'insert'
      end
      if mode:match '^[Rr]' then
        return 'replace'
      end
      if mode:match '^c' then
        return 'command'
      end

      return 'normal'
    end

    local function build_theme()
      package.loaded['lualine.themes.auto'] = nil
      local auto_theme = require 'lualine.themes.auto'
      local normal_fg = first_hl_color({ 'Normal', 'NormalNC' }, 'fg')
      local flat_bg = first_hl_color({ 'NormalFloat', 'NeoTreeNormal', 'NvimTreeNormal', 'StatusLine', 'Pmenu', 'PmenuSel', 'Normal' }, 'bg')

      local mode_fg = {}
      for _, mode in ipairs(modes) do
        local section_a = ((auto_theme[mode] or {}).a or {})
        mode_fg[mode] = to_hex(section_a.bg or section_a.fg)
      end

      return flatten_theme(auto_theme, normal_fg, flat_bg), {
        normal_fg = normal_fg,
        flat_bg = flat_bg,
        mode_fg = mode_fg,
      }
    end

    local function setup_lualine()
      local flat_theme, palette = build_theme()

      local function mode_accent()
        return palette.mode_fg[current_mode_key()] or palette.normal_fg
      end

      local function accent_color(style)
        return function()
          return vim.tbl_extend('force', {
            fg = mode_accent(),
            bg = palette.flat_bg,
          }, style or {})
        end
      end

      require('lualine').setup {
        options = {
          theme = flat_theme,
          component_separators = '',
          section_separators = '',
        },
        sections = {
          lualine_a = {
            {
              function()
                return icons.lualine.left_bar
              end,
              color = accent_color(),
              padding = { left = 0, right = 1 },
            },
            {
              'mode',
              color = accent_color { gui = 'bold' },
              separator = { left = '' },
              padding = { left = 0, right = 1 },
            },
          },
          lualine_b = {
            {
              'branch',
              icon = icons.lualine.branch,
            },
            {
              'diff',
            },
            'filename',
          },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'filetype', 'fileformat', 'progress' },
          lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = { 'branch' },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'filetype' },
          lualine_z = { 'fileformat' },
        },
        tabline = {},
        extensions = {},
      }
    end

    setup_lualine()

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('LualineThemeRefresh', { clear = true }),
      callback = function()
        vim.schedule(setup_lualine)
      end,
    })
  end,
}
