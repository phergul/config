return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>sR',
      function()
        require('spectre').open()
      end,
      desc = 'Search and Replace (Project)',
    },
  },
}
