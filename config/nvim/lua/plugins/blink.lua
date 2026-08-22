return {
  -- {
  --   'folke/sidekick.nvim',
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'saghen/blink.cmp',
  --     'williamboman/mason.nvim',
  --   },
  --   opts = {
  --     nes = {
  --       enabled = true,
  --       debounce = 300,
  --     },
  --   },
  --   keys = {
  --     {
  --       '<leader>cc',
  --       function()
  --         local nes = require 'sidekick.nes'
  --         nes.toggle()
  --         if nes.enabled then
  --           vim.notify('Sidekick NES: ON', vim.log.levels.INFO)
  --         else
  --           vim.notify('Sidekick NES: OFF', vim.log.levels.INFO)
  --         end
  --       end,
  --       mode = { 'n', 'v' },
  --       desc = 'Toggle Sidekick NES',
  --     },
  --     {
  --       '§',
  --       function()
  --         if require('sidekick').nes_jump_or_apply() then
  --           return
  --         end
  --       end,
  --       mode = { 'n', 'v' },
  --       desc = 'Apply Copilot Suggestion',
  --     },
  --   },
  -- },
  --
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      -- 'giuxtaposition/blink-cmp-copilot',
      'xzbdmw/colorful-menu.nvim',
    },
    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = function()
      local border = require('config.ui').get_border()

      return {
        keymap = {
          preset = 'none',
          ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },

          providers = {
            -- copilot = {
            --   name = 'copilot',
            --   module = 'blink-cmp-copilot',
            --   score_offset = 100,
            --   async = true,
            -- },
          },
        },

        appearance = {
          -- use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono',
        },

        completion = {
          menu = {
            border = border,

            draw = {
              columns = {
                { 'kind_icon' },
                { 'label', 'label_description', gap = 1 },
                -- { 'source_name' },
              },
              components = {
                label = {
                  text = function(ctx)
                    return require('colorful-menu').blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require('colorful-menu').blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },

          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = {
              border = border,
            },
          },
        },

        signature = {
          enabled = true,
          window = { border = border },
        },
      }
    end,
  },

  -- {
  --   'zbirenbaum/copilot.lua',
  --   cmd = 'Copilot',
  --   event = 'InsertEnter',
  --   opts = {
  --     suggestion = { enabled = false },
  --     panel = { enabled = false },
  --     server_opts_overrides = {
  --       settings = {
  --         advanced = {
  --           listCount = 10,
  --           inlineSuggestCount = 3,
  --         },
  --       },
  --     },
  --   },
  -- },
}
