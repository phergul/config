return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    indent = {
      char = require('config.icons').indent.bar,
      highlight = { 'IblIndent' },
    },
    whitespace = {
      remove_blankline_trail = true,
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      highlight = { 'IblScope' },
      include = {
        node_type = { ['*'] = { '*' } },
      },
    },
  },
  config = function(_, opts)
    require('ibl').setup(opts)
  end,
}
