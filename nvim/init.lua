require 'config.options'
require 'config.keymaps'
require 'config.commands'
require 'config.lazy'

vim.schedule(function()
  vim.keymap.set('i', '<Esc>', '<C-c>', { noremap = true, silent = true })
end)

-- local theme_file = vim.fn.stdpath 'config' .. '/theme.conf'
-- local Themify = require 'themify.api'
--
-- local function load_theme()
--   if vim.fn.filereadable(theme_file) ~= 1 then
--     return
--   end
--
--   local lines = vim.fn.readfile(theme_file)
--   if not lines or #lines < 2 then
--     return
--   end
--
--   local colorscheme_id = (lines[1] ~= 'nil') and lines[1] or nil
--   local theme = lines[2]
--
--   if theme == nil or theme == '' then
--     return
--   end
--
--   Themify.set_current(colorscheme_id, theme)
-- end
--
-- load_theme()
--
-- vim.api.nvim_create_user_command('ReloadTheme', load_theme, {})
