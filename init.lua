require 'config.options'
require 'config.keymaps'
require 'config.commands'
require 'config.lazy'

vim.schedule(function()
  vim.keymap.set('i', '<Esc>', '<C-c>', { noremap = true, silent = true })
end)
