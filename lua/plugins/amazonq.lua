return {
  -- {
  --   name = 'amazonq',
  --   url = 'https://github.com/awslabs/amazonq.nvim.git',
  --   config = function()
  --     require('amazonq').setup {
  --       ssoStartUrl = 'https://genesys-cloud.awsapps.com/start',
  --       on_chat_open = function()
  --         vim.cmd [[
  -- 	vertical botright split
  -- 	vertical resize 80
  -- 	set wrap breakindent nonumber norelativenumber nolist
  --   ]]
  --       end,
  --       vim.keymap.set('n', '<leader>cc', '<cmd>AmazonQ<cr>', { desc = 'AmazonQ' }),
  --       vim.keymap.set('i', '<esc>', '<c-\\><c-n>', { buffer = true }),
  --     }
  --   end,
  -- },
}
