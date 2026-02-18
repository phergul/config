return {
  'phergul/go-type-hover.nvim',
  opts = {
    float = {
      show_footer = false,
    },
  },
  config = function(_, opts)
    require('go_type_hover').setup(opts)
  end,
}
