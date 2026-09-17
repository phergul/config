return {
  'rachartier/tiny-inline-diagnostic.nvim',
  -- Load before the LSP can attach so the plugin sees LspAttach.
  event = { 'BufReadPre', 'BufNewFile' },
  priority = 1000,
  config = function()
    require('tiny-inline-diagnostic').setup {
      options = {
        multilines = {
          enabled = true,
        },
      },
    }
    vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
  end,
}
