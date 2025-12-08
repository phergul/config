local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local M = {}

local function get_go_tests()
  local tests = {}
  for line in io.popen("grep -n '^func Test' " .. vim.fn.expand '%'):lines() do
    local lnum, name = line:match '^(%d+):func (%w+)'
    if name then
      table.insert(tests, { name = name, lnum = tonumber(lnum) })
    end
  end
  return tests
end

M.run_all_go_tests = function()
  local file_dir = vim.fn.expand '%:p:h'
  local file_name = vim.fn.expand '%:t'

  local cmd = string.format("zellij run -d right -n %s --cwd %s -- sh -c 'richgo test -v %s'", file_name, file_dir, file_name)

  vim.fn.jobstart(cmd, { detach = true })
end

M.go_test_picker = function()
  local tests = get_go_tests()

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
          local test_name = selection.value
          local file_dir = vim.fn.expand '%:p:h'

          local cmd = string.format('zellij run -d right -n %s --cwd %s -- sh -c \'richgo test -run "^%s$" -v\'', test_name, file_dir, test_name)
          vim.fn.jobstart(cmd, { detach = true })
        end)
        return true
      end,
    })
    :find()
end

return M
