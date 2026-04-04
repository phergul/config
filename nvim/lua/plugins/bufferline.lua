return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local function delete_current_buffer()
      local current = vim.api.nvim_get_current_buf()

      if vim.bo[current].filetype == 'neo-tree' then
        return
      end

      local replacement = nil
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
          replacement = buf
          break
        end
      end

      if replacement then
        vim.api.nvim_set_current_buf(replacement)
      else
        vim.cmd.enew()
      end

      vim.api.nvim_buf_delete(current, {})
    end

    vim.opt.termguicolors = true
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        numbers = 'none',
        themable = true,
        diagnostics = 'nvim_lsp',
        separator_style = 'thin', -- "slant" | "slope" | "thick" | "thin"
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Tree',
            highlight = 'Directory',
            separator = true,
          },
        },
      },
    }
    vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>')
    vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>')

    vim.keymap.set('n', '<leader>bn', '<Cmd>BufferLineMoveNext<CR>')
    vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineMovePrev<CR>')

    vim.keymap.set('n', '<leader>bb', '<Cmd>BufferLinePick<CR>')

    vim.keymap.set('n', '<leader>bd', delete_current_buffer, { desc = 'Delete current buffer' })
    vim.keymap.set('n', '<leader>bD', '<Cmd>BufferLineCloseOthers<CR>')
  end,
}
