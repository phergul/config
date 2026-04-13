local M = {}
local state_file = vim.fn.stdpath 'state' .. '/theme_mode'

M.themes = {
  dark = {
    background = 'dark',
    colorscheme = 'catppuccin-macchiato',
  },
  light = {
    background = 'light',
    colorscheme = 'catppuccin-latte',
  },
}

M.default_mode = 'dark'

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'theme' })
end

local function lualine_refresh()
  pcall(vim.cmd, 'silent! LualineRefresh')
end

function M.current_mode()
  local mode = vim.g.theme_mode
  if mode == 'light' or mode == 'dark' then
    return mode
  end
  return M.default_mode
end

local function read_persisted_mode()
  if vim.fn.filereadable(state_file) == 0 then
    return nil
  end

  local ok, lines = pcall(vim.fn.readfile, state_file)
  if not ok or not lines or not lines[1] then
    return nil
  end

  local mode = vim.trim(lines[1])
  if mode == 'light' or mode == 'dark' then
    return mode
  end

  return nil
end

local function persist_mode(mode)
  pcall(vim.fn.writefile, { mode }, state_file)
end

function M.apply(mode)
  local chosen = M.themes[mode]
  if not chosen then
    notify(("Unknown theme mode '%s'"):format(mode), vim.log.levels.ERROR)
    return false
  end

  vim.g.theme_mode = mode
  vim.o.background = chosen.background

  local ok, err = pcall(vim.cmd.colorscheme, chosen.colorscheme)
  if not ok then
    notify(("Failed to load colorscheme '%s': %s"):format(chosen.colorscheme, err), vim.log.levels.ERROR)
    return false
  end

  lualine_refresh()
  persist_mode(mode)
  return true
end

function M.toggle()
  local next_mode = M.current_mode() == 'dark' and 'light' or 'dark'
  if M.apply(next_mode) then
    notify(('Theme mode: %s'):format(next_mode))
  end
end

function M.register_commands()
  pcall(vim.api.nvim_del_user_command, 'ThemeDark')
  pcall(vim.api.nvim_del_user_command, 'ThemeLight')
  pcall(vim.api.nvim_del_user_command, 'ThemeToggle')
  pcall(vim.api.nvim_del_user_command, 'ThemeSet')

  vim.api.nvim_create_user_command('ThemeDark', function()
    if M.apply 'dark' then
      notify 'Theme mode: dark'
    end
  end, { desc = 'Switch to dark theme mode' })

  vim.api.nvim_create_user_command('ThemeLight', function()
    if M.apply 'light' then
      notify 'Theme mode: light'
    end
  end, { desc = 'Switch to light theme mode' })

  vim.api.nvim_create_user_command('ThemeToggle', function()
    M.toggle()
  end, { desc = 'Toggle between dark and light theme mode' })

  vim.api.nvim_create_user_command('ThemeSet', function(opts)
    if M.apply(opts.args) then
      notify(('Theme mode: %s'):format(opts.args))
    end
  end, {
    desc = 'Set theme mode explicitly',
    nargs = 1,
    complete = function()
      return { 'dark', 'light' }
    end,
  })
end

function M.setup()
  M.register_commands()
  local mode = M.current_mode()
  if vim.g.theme_mode == nil then
    mode = read_persisted_mode() or M.default_mode
  end
  M.apply(mode)
end

return M
