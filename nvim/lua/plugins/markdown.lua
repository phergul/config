return {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
  --   -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {
  --     enabled = true, -- whether rendering is on by default
  --     render_modes = { 'n', 'c', 't' }, -- in which modes to render markdown
  --     preset = 'none', -- use "obsidian" / "lazy", or "none" to start custom
  --     max_file_size = 10.0, -- maximum MB for rendering
  --     file_types = { 'markdown' }, -- which filetypes this should run on
  --     -- you can override many parts (headings, code blocks, lists, etc.) — see below
  --   },
  --   config = function(_, opts)
  --     require('render-markdown').setup(opts)
  --   end,
}
