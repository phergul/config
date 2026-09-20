return {
  'nvim-neotest/neotest',
  ft = 'go',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neotest/nvim-nio',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fredrikaverpil/neotest-golang',
  },
  keys = {
    {
      '<leader>rr',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      '<leader>rf',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run tests in current file',
    },
    {
      '<leader>rt',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle test summary',
    },
    {
      '<leader>ro',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Open test output',
    },
    {
      '<leader>rs',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop test',
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-golang',
      },
    }
  end,
}
