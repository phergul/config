return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = 'open_default',
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        commands = {
          trash = function(state)
            local inputs = require 'neo-tree.ui.inputs'
            local path = state.tree:get_node().path
            local utils = require 'neo-tree.utils'
            local _, name = utils.split_path(path)

            local msg = string.format("Are you sure you want to trash '%s'?", name)

            inputs.confirm(msg, function(confirmed)
              if not confirmed then
                return
              end

              pcall(function()
                vim.fn.system { 'trash', vim.fn.fnameescape(path) }
                if vim.v.shell_error ~= 0 then
                  msg = 'trash command failed.'
                  vim.notify(msg, vim.log.levels.ERROR, { title = 'Neo-tree' })
                end
              end)

              require('neo-tree.sources.manager').refresh(state.name)
            end)
          end,

          trash_visual = function(state, selected_nodes)
            local inputs = require 'neo-tree.ui.inputs'
            local msg = 'Are you sure you want to trash ' .. #selected_nodes .. ' files ?'

            inputs.confirm(msg, function(confirmed)
              if not confirmed then
                return
              end

              for _, node in ipairs(selected_nodes) do
                pcall(function()
                  vim.fn.system { 'trash', vim.fn.fnameescape(node.path) }
                  if vim.v.shell_error ~= 0 then
                    msg = 'trash command failed.'
                    vim.notify(msg, vim.log.levels.ERROR, { title = 'Neo-tree' })
                  end
                end)
              end

              require('neo-tree.sources.manager').refresh(state.name)
            end)
          end,
        },
      },
      window = {
        width = 32,
        mappings = {
          ['<space>'] = 'toggle_node',
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<cr>'] = 'open',
          ['d'] = 'trash',
          ['D'] = 'trash_visual',
        },
      },
    }

    vim.keymap.set('n', '<leader>ee', '<cmd>Neotree toggle filesystem reveal left<CR>', {
      desc = 'Open File Explorer',
    })

    vim.keymap.set('n', '<leader>ef', '<cmd>Neotree focus filesystem reveal left<CR>', {
      desc = 'Open File Explorer at current file',
    })
  end,
}
