return {
  'sindrets/diffview.nvim',

  vim.keymap.set('n', '<leader>dv', ':DiffviewOpen<CR>', { desc = 'Open Diffview' }),
  vim.keymap.set('n', '<leader>dc', ':DiffviewClose<CR>', { desc = 'Close Diffview' }),

  vim.keymap.set('n', '<leader>dff', ':DiffviewFileHistory %<CR>', { desc = 'Open Diffview for current file' }),
  vim.keymap.set('n', '<leader>dfa', ':DiffviewFileHistory<CR>', { desc = 'Open Diffview for all files' }),
}
