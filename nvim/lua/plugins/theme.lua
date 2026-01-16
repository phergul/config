return {
  {
    'spacedust.nvim',
    dev = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'spacedust'
    end,
  },
}
