return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('spectre').setup { is_block_ui_break = true }
  end,
  keys = {
    {
      '<leader>sR',
      function()
        require('spectre').open()
      end,
      desc = 'Search and Replace (Project)',
    },
    {
      '<leader>sV',
      function()
        require('spectre').open_visual { select_word = true }
      end,
      desc = 'Search current word',
    },
  },
}
