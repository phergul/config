vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.opt.autoread = true

local group = vim.api.nvim_create_augroup('AutoReadChangedFiles', { clear = true })

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = group,
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = group,
  pattern = '*',
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.INFO, {
      title = 'nvim',
    })
  end,
})

local ui = require 'config.ui'

vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover { border = ui.get_border() }
end, { desc = 'LSP hover with border' })

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
