return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    -- local colours = _G.GhosttyPalette or {}
    -- local custom_theme = {
    --   normal = {
    --     a = { bg = colours.green, fg = colours.bg, gui = 'bold' },
    --     b = { bg = colours.black, fg = colours.white },
    --     c = { bg = colours.bg, fg = colours.fg },
    --   },
    --   insert = {
    --     a = { bg = colours.red, fg = colours.white, gui = 'bold' },
    --   },
    --   visual = {
    --     a = { bg = colours.yellow, fg = colours.bg, gui = 'bold' },
    --   },
    --   replace = {
    --     a = { bg = colours.b_red, fg = colours.bg, gui = 'bold' },
    --   },
    --   inactive = {
    --     a = { bg = colours.bg, fg = colours.black },
    --     b = { bg = colours.bg, fg = colours.black },
    --     c = { bg = colours.bg, fg = colours.black },
    --   },
    -- }
    --
    -- -- stylua: ignore
    --    local colors = {
    --      blue = '#80a0ff',
    --      cyan = '#79dac8',
    --      black = '#080808',
    --      white = '#c6c6c6',
    --      red = '#ff5189',
    --      grey = '#303030',
    --      lightgrey = '#73788B',
    --    }
    --
    --    local bubbles_theme = {
    --      normal = {
    --        a = { fg = colors.black, bg = colors.lightgrey },
    --        b = { fg = colors.white, bg = colors.grey },
    --        c = { fg = colors.white },
    --      },
    --
    --      insert = { a = { fg = colors.black, bg = colors.blue } },
    --      visual = { a = { fg = colors.black, bg = colors.cyan } },
    --      replace = { a = { fg = colors.black, bg = colors.red } },
    --
    --      inactive = {
    --        a = { fg = colors.white, bg = colors.black },
    --        b = { fg = colors.white, bg = colors.black },
    --        c = { fg = colors.white },
    --      },
    --    }

    require('lualine').setup {
      options = {
        theme = require('spacedust.lualine').setup(),
        component_separators = '',
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_b = { 'branch', 'diff', 'filename' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'filetype', 'progress' },
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
