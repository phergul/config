vim.keymap.set('n', '<leader>w', '<cmd>w<cr><esc>', { desc = 'Write file' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+p')

-- vim.keymap.set('n', '<D-h>', '<C-w>h', opts)
-- vim.keymap.set('n', '<D-j>', '<C-w>j', opts)
-- vim.keymap.set('n', '<D-k>', '<C-w>k', opts)
-- vim.keymap.set('n', '<D-l>', '<C-w>l', opts)
--
-- vim.keymap.set('i', '<D-h>', '<Esc><C-w>h', opts)
-- vim.keymap.set('i', '<D-j>', '<Esc><C-w>j', opts)
-- vim.keymap.set('i', '<D-k>', '<Esc><C-w>k', opts)
-- vim.keymap.set('i', '<D-l>', '<Esc><C-w>l', opts)
--
-- vim.keymap.set('t', '<D-h>', [[<C-\><C-n><C-w>h]], opts)
-- vim.keymap.set('t', '<D-j>', [[<C-\><C-n><C-w>j]], opts)
-- vim.keymap.set('t', '<D-k>', [[<C-\><C-n><C-w>k]], opts)
-- vim.keymap.set('t', '<D-l>', [[<C-\><C-n><C-w>l]], opts)

vim.keymap.set('n', '<S-D-h>', 'gT', opts)
vim.keymap.set('n', '<S-D-l>', 'gt', opts)

vim.keymap.set('i', '<S-D-h>', '<Esc>gT', opts)
vim.keymap.set('i', '<S-D-l>', '<Esc>gt', opts)

vim.keymap.set('n', '<leader>rr', function()
  require('custom_telescope_pickers.go_test_picker').go_test_picker()
end, {})

vim.keymap.set('n', '<leader>rf', function()
  require('custom_telescope_pickers.go_test_picker').run_all_go_tests()
end, {})

vim.keymap.set('n', '<leader>hb', '<cmd>Git blame<cr>', { desc = 'Toggle git blame' })
