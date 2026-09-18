return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function delete_current_buffer()
      if vim.bo.filetype == 'neo-tree' then
        return
      end

      -- Let Neovim choose the alternate/next buffer and handle modified
      -- buffers correctly. This also works for deleted or unnamed files.
      vim.cmd.bdelete()
    end

    vim.opt.termguicolors = true

    require('bufferline').setup {
      options = {
        mode = 'buffers',
        numbers = 'none',
        themable = false,
        -- BufferLineCloseOthers and mouse actions use this command too.
        -- Avoid bdelete! so unsaved changes are never discarded silently.
        close_command = 'bdelete %d',
        right_mouse_command = 'bdelete %d',
        diagnostics = 'nvim_lsp',
        separator_style = 'thin', -- "slant" | "slope" | "thick" | "thin"
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Tree',
            highlight = 'Directory',
            separator = true,
          },
        },
      },
    }
    vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>')
    vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>')

    vim.keymap.set('n', '<leader>bn', '<Cmd>BufferLineMoveNext<CR>')
    vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineMovePrev<CR>')

    vim.keymap.set('n', '<leader>bb', '<Cmd>BufferLinePick<CR>')

    vim.keymap.set('n', '<leader>bd', delete_current_buffer, { desc = 'Delete current buffer' })
    vim.keymap.set('n', '<leader>bD', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Delete other buffers' })
  end,
}
