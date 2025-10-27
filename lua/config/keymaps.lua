vim.keymap.set('n', '<leader>w', '<cmd>w<cr><esc>', { desc = 'Write file' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
