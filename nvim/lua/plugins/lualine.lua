return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    require('lualine').setup {
      options = {
        -- theme = require('spacedust').get_lualine_theme(),
        theme = 'auto',
        component_separators = '',
        section_separators = '',
        -- section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_b = {
          {
            'branch',
            icon = '',
          },
          'diff',
          'filename',
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'filetype', 'fileformat', 'progress' },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'filetype' },
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {},
    }
  end,
}
