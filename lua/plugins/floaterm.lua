return {
  {
    'nvzone/floaterm',
    dependencies = { 'nvzone/volt' },
    cmd = 'FloatermToggle',
    lazy = false,
    config = function()
      local floaterm = require 'floaterm'
      floaterm.setup {
        border = true,
        size = { h = 80, w = 80 },
        mappings = {
          term = function(buf)
            -- vim.keymap.set('t', '<C-`>', function()
            --   floaterm.toggle()
            -- end, { buffer = buf, silent = true })
            -- vim.keymap.set('t', '<C-s>', function()
            --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', false)
            --   require('floaterm.api').switch_wins()
            -- end, { buffer = buf, silent = true, desc = 'Switch between Floaterm windows' })
          end,
        },
      }

      vim.keymap.set({ 'n', 't' }, '<C-`>', '<cmd>FloatermToggle<cr>', { desc = 'Toggle Floaterm', silent = true })
    end,
  },
  {
    -- 'voldikss/vim-floaterm',
    -- cmd = { 'FloatermNew', 'FloatermToggle', 'FloatermSend' },
    -- keys = {
    --   { '<leader>tf', '<cmd>FloatermToggle<cr>', desc = 'Toggle Floaterm' },
    --   { '<leader>tn', '<cmd>FloatermNew<cr>', desc = 'New Floaterm' },
    --   { '<leader>tl', '<cmd>FloatermList<cr>', desc = 'List Floaterms' },
    --   { '<leader>tk', '<cmd>FloatermKill<cr>', desc = 'Kill current Floaterm' },
    --   { '<leader>t[', '<cmd>FloatermPrev<cr>', desc = 'Previous Floaterm' },
    --   { '<leader>t]', '<cmd>FloatermNext<cr>', desc = 'Next Floaterm' },
    --   { '<C-`>', '<cmd>FloatermToggle<cr>', mode = { 'n', 't' }, desc = 'Toggle Floaterm (any mode)' },
    --   { '<esc>', [[<C-\><C-n]], mode = { 'n', 't' } },
    -- },
    -- init = function()
    --   vim.g.floaterm_title = ' Terminal [$1/$2]'
    --   vim.g.floaterm_width = 0.9
    --   vim.g.floaterm_height = 0.85
    --   vim.g.floaterm_autoclose = 0
    --   vim.g.floaterm_reuse = 1
    --   vim.g.floaterm_borderchars = '─│─│╭╮╯╰'
    --
    --   -- vim.api.nvim_create_autocmd('TermOpen', {
    --   --   pattern = 'term://*floaterm*',
    --   --   callback = function()
    --   --     local opts = { buffer = 0, silent = true }
    --   --     vim.keymap.set('t', '<C-`>', function()
    --   --       vim.cmd 'stopinsert'
    --   --       vim.defer_fn(function()
    --   --         vim.cmd 'FloatermHide'
    --   --       end, 10)
    --   --     end, opts)
    --   --   end,
    --   -- })
    -- end,
  },
}
