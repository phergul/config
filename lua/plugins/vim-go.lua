return {
  'fatih/vim-go',
  build = ':GoInstallBinaries',
  ft = 'go',
  init = function()
    vim.g.go_term_enabled = 1
    vim.g.go_term_mode = 'floaterm'
    vim.g.go_term_close_on_exit = 0
    vim.g.go_term_reuse = 1
    vim.g.go_test_show_name = 1
    vim.g.go_echo_command_info = 0
    vim.g.go_term_height = 15
  end,
  vim.keymap.set('n', '<leader>ttf', '<cmd>GoTestFile<cr>', { desc = 'Run Go tests in current file' }),
  vim.keymap.set('n', '<leader>ttc', '<cmd>GoTestFunc<cr>', { desc = 'Run current Go test' }),
}
