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
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'rose-pine/neovim',
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        styles = {
          transparency = true,
        },
      }
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
  },
}
