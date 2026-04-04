return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
  opts = {
    enabled = true,
    render_modes = { 'n', 'c', 't' },
    preset = 'none',
    max_file_size = 10.0,
    file_types = { 'markdown' },
  },
  config = function(_, opts)
    require('render-markdown').setup(opts)
  end,
}
