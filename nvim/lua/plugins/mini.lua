return {
  'nvim-mini/mini.nvim',
  version = '*',
  config = function()
    -- files
    require('mini.files').setup {}
    vim.keymap.set('n', '<leader>ee', function()
      require('mini.files').open()
    end, { desc = 'Open File Explorer' })

    vim.keymap.set('n', '<leader>ef', function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = buf_name ~= '' and buf_name or vim.fn.getcwd()
      require('mini.files').open(path, true)
    end, { desc = 'Open File Explorer at current file' })

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
