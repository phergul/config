return {
  -- {
  --   'phergul/spacedust.nvim',
  --   dev = true,
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'spacedust'
  --   end,
  -- },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },
}
