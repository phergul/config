local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local M = {}

local function get_current_file_dir()
  return vim.fn.expand '%:p:h'
end

local function get_current_file_name()
  return vim.fn.expand '%:t'
end

local function get_go_tests()
  local tests = {}
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for lnum, line in ipairs(lines) do
    local name = line:match '^%s*func%s+(Test[%w_]+)%s*%('
    if name then
      table.insert(tests, { name = name, lnum = lnum })
    end
  end
  return tests
end

local function escape_re2(str)
  return (str:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '\\%1'))
end

local function start_test_in_zellij(name, file_dir, args)
  local cmd = {
    'zellij',
    'run',
    '-d',
    'right',
    '-n',
    name,
    '--cwd',
    file_dir,
    '--',
    'richgo',
    'test',
  }
  vim.list_extend(cmd, args)

  local job_id = vim.fn.jobstart(cmd, { detach = true })
  if job_id <= 0 then
    vim.notify('Failed to start zellij test pane', vim.log.levels.ERROR)
  end
end

M.run_all_go_tests = function()
  local tests = get_go_tests()
  if #tests == 0 then
    vim.notify('No tests found in current file', vim.log.levels.WARN)
    return
  end

  local file_dir = get_current_file_dir()
  local file_name = get_current_file_name()
  local parts = {}
  for _, test in ipairs(tests) do
    parts[#parts + 1] = escape_re2(test.name)
  end

  local run_pattern = '^(' .. table.concat(parts, '|') .. ')$'
  start_test_in_zellij(file_name, file_dir, { '-run', run_pattern, '-v', '.' })
end

M.go_test_picker = function()
  local tests = get_go_tests()
  if #tests == 0 then
    vim.notify('No tests found in current file', vim.log.levels.WARN)
    return
  end

  pickers
    .new({}, {
      prompt_title = 'Go Tests',
      finder = finders.new_table {
        results = tests,
        entry_maker = function(t)
          return {
            value = t.name,
            display = t.name,
            ordinal = t.name,
            lnum = t.lnum,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection or not selection.value then
            vim.notify('No test selected', vim.log.levels.WARN)
            return
          end

          local test_name = selection.value
          local file_dir = get_current_file_dir()

          local run_pattern = '^' .. escape_re2(test_name) .. '$'
          start_test_in_zellij(test_name, file_dir, { '-run', run_pattern, '-v', '.' })
        end)
        return true
      end,
    })
    :find()
end

return M
