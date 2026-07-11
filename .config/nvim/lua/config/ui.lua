local M = {}

M.border = 'single'

function M.set_border(style)
  M.border = style
  vim.o.winborder = style
end

function M.get_border()
  return M.border
end

M.set_border(M.border)

return M
