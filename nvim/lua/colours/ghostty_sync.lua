_G.GhosttyPalette = {
  bg = '#0a1e24',
  bg_dark = '#050f12',
  bg_alt = '#122a31',
  fg = '#ecf0c1',
  cursor = '#708284',
  cur_txt = '#002831',
  sel_bg = '#0a385c',
  sel_fg = '#ffffff',
  lsp_bg = '#1e1e1e',
  -- ANSI Palette
  black = '#6e5346',
  red = '#e35b00',
  green = '#5cab96',
  yellow = '#e3cd7b',
  blue = '#0f548b',
  magenta = '#e35b00',
  cyan = '#06afc7',
  white = '#f0f1ce',
  -- Brights
  b_black = '#684c31',
  b_red = '#ff8a3a',
  b_green = '#aecab8',
  b_yellow = '#ffc878',
  b_blue = '#67a0ce',
  b_magenta = '#ff8a3a',
  b_cyan = '#83a7b4',
  b_white = '#fefff1',
}

local colors = _G.GhosttyPalette

-- Reset existing highlights
vim.cmd 'highlight clear'
if vim.fn.exists 'syntax_on' then
  vim.cmd 'syntax reset'
end
vim.g.colors_name = 'ghostty_sync'

-- Helper function to set highlights
local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- --- UI HIGHLIGHTS ---
hi('Normal', { fg = colors.fg, bg = colors.bg })
hi('NormalFloat', { fg = colors.fg, bg = colors.lsp_bg })
hi('FloatBorder', { fg = colors.fg, bg = colors.bg_alt })
hi('FloatTitle', { fg = colors.fg, bg = colors.bg_alt, bold = true })
hi('Visual', { fg = colors.sel_fg, bg = colors.sel_bg })
hi('Cursor', { fg = colors.cur_txt, bg = colors.cursor })
hi('LineNr', { fg = colors.black })
hi('CursorLine', { bg = '#122a31' })
hi('CursorLineNr', { fg = colors.yellow, bold = true })
hi('StatusLine', { fg = colors.fg, bg = colors.black })
hi('Pmenu', { fg = colors.fg, bg = '#122a31' })
hi('MsgArea', { fg = colors.fg, bg = colors.bg_alt })
hi('VertSplit', { fg = colors.black })
hi('@markup.raw.markdown_inline', { bg = colors.lsp_bg })
hi('@markup.raw.block.markdown', { bg = colors.lsp_bg })

-- Link these together to ensure the "lua" code inside docs matches
hi('MarkdownCode', { bg = colors.bg_alt })
hi('MarkdownCodeBlock', { bg = colors.bg_alt })

-- --- SYNTAX HIGHLIGHTS ---
hi('Comment', { fg = colors.black, italic = true })
hi('Constant', { fg = colors.cyan })
hi('String', { fg = colors.green })
hi('Identifier', { fg = colors.b_blue })
hi('Function', { fg = colors.blue, bold = true })
hi('Statement', { fg = colors.red })
hi('PreProc', { fg = colors.yellow })
hi('Type', { fg = colors.b_cyan })
hi('Special', { fg = colors.b_yellow })
hi('Todo', { fg = colors.bg, bg = colors.yellow, bold = true })
hi('Error', { fg = colors.red, bold = true })

-- --- TREE-SITTER (Modern Highlighting) ---
hi('@variable', { fg = colors.fg })
hi('@keyword', { fg = colors.red })
hi('@function', { fg = colors.blue })
hi('@property', { fg = colors.b_cyan })
