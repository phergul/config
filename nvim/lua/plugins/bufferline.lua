return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.opt.termguicolors = true
    local colours = _G.GhosttyPalette or {}
    -- local mocha = require('catppuccin.palettes').get_palette 'mocha'
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        numbers = 'none',
        themable = true,
        diagnostics = 'nvim_lsp',
        separator_style = 'thin', -- "slant" | "slope" | "thick" | "thin"
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            separator = true,
          },
        },
      },
      highlights = {
        -- The empty space behind the tabs
        fill = {
          bg = colours.bg_dark,
        },
        -- Inactive tab appearance
        background = {
          fg = colours.black,
          bg = colours.bg_dark,
        },
        -- Active tab
        buffer_selected = {
          fg = colours.fg,
          bg = colours.bg,
          bold = true,
          italic = false,
        },
        -- The little focus bar next to the active tab
        indicator_selected = {
          fg = colours.green,
          bg = colours.bg,
        },
        -- Separators between inactive tabs
        separator = {
          fg = colours.bg_dark,
          bg = colours.bg_dark,
        },
        -- Separators next to the active tab
        separator_selected = {
          fg = colours.bg_dark,
          bg = colours.bg,
        },
        -- Modified buffers (unsaved changes)
        modified = {
          fg = colours.yellow,
          bg = colours.bg_dark,
        },
        modified_selected = {
          fg = colours.yellow,
          bg = colours.bg,
        },
      },
      -- highlights = require('catppuccin.special.bufferline').get_theme {
      --   custom = {
      --     mocha = {
      --       -- buffer_selected = { bg = '#1e1e2e' },
      --       buffer_selected = {
      --         fg = mocha.text,
      --         bg = mocha.base,
      --         bold = true,
      --       },
      --       warning_selected = { bg = mocha.base },
      --       warning_diagnostic_selected = { bg = mocha.base },
      --
      --       error_selected = { bg = mocha.base },
      --       error_diagnostic_selected = { bg = mocha.base },
      --
      --       info_selected = { bg = mocha.base },
      --       info_diagnostic_selected = { bg = mocha.base },
      --
      --       hint_selected = { bg = mocha.base },
      --       hint_diagnostic_selected = { bg = mocha.base },
      --
      --       duplicate_selected = { bg = mocha.base },
      --     },
      --   },
      -- },
    }
    vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>')
    vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>')

    vim.keymap.set('n', '<leader>bn', '<Cmd>BufferLineMoveNext<CR>')
    vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineMovePrev<CR>')

    vim.keymap.set('n', '<leader>bb', '<Cmd>BufferLinePick<CR>')

    vim.keymap.set('n', '<leader>bd', '<Cmd>bdelete<CR>')
    vim.keymap.set('n', '<leader>bD', '<Cmd>BufferLineCloseOthers<CR>')
  end,
}
