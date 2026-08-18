return {
  'nvim-mini/mini.nvim',
  version = '*',
  config = function()
    -- files
    require('mini.files').setup {}
    -- open file explorer with <leader>e opened on the current file with panels to the root shown
    vim.keymap.set('n', '<leader>e', function()
      local MiniFiles = require 'mini.files'
      MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      MiniFiles.reveal_cwd()
    end, { desc = 'Open file explorer' })

    -- ai
    require('mini.ai').setup()

    -- pairs
    require('mini.pairs').setup()

    -- move
    require('mini.move').setup {
      mappings = {
        left = '<C-h>',
        right = '<C-l>',
        down = '<C-j>',
        up = '<C-k>',
      },
    }

    -- surround
    require('mini.surround').setup()
  end,
}
