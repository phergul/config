local M = {}

M.ui = {
  ellipsis = '…',
}

M.borders = {
  single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  none = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
}

M.lualine = {
  left_bar = '▎',
  branch = '',
}

M.diagnostics = {
  error = '󰅚 ',
  warn = '󰀪 ',
  info = '󰋽 ',
  hint = '󰌶 ',
}

M.indent = {
  bar = '│',
}

M.git_changes = {
  modified = '󰏫',
  added = '󰐖',
  staged = '󰄬',
}

M.files = {
  default = '',
}

return M
