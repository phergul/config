local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup {
  -- This config is deployed by Home Manager as a read-only Nix-store symlink.
  -- Keep lazy.nvim's generated lockfile in Neovim's writable data directory.
  lockfile = vim.fn.stdpath 'data' .. '/lazy-lock.json',
  spec = {
    { import = 'plugins' },
  },
  dev = {
    path = '~/dev/lua',
    fallback = false,
  },
}
