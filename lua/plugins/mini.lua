return {
  { 'nvim-mini/mini.nvim', version = false },
  {
    'nvim-mini/mini.files',
    config = function()
      local minifiles = require 'mini.files'
      minifiles.setup {}
      vim.keymap.set('n', '<leader>ee', '<cmd>lua MiniFiles.open()<CR>', { desc = 'Open File Explorer' })
      vim.keymap.set('n', '<leader>ef', function()
        minifiles.open(vim.api.nvim_buf_get_name(0), false)
        minifiles.reveal_cwd()
      end, { desc = 'Open File Explorer at current file' })
    end,
  },
  {
    'nvim-mini/mini.statusline',
    config = function()
      local statusline = require 'mini.statusline'

      statusline.setup {
        use_icons = true,
        set_vim_settings = true,
      }

      statusline.section_git = function()
        return ''
      end

      local function git_info()
        local branch = vim.b.gitsigns_head
        local diff = vim.b.gitsigns_status_dict

        if not branch then
          return ''
        end

        local added = diff and diff.added and ('+' .. diff.added) or ''
        local changed = diff and diff.changed and ('~' .. diff.changed) or ''
        local removed = diff and diff.removed and ('-' .. diff.removed) or ''

        local parts = { branch, added, changed, removed }
        return ' ' .. table.concat(
          vim.tbl_filter(function(s)
            return s ~= ''
          end, parts),
          ' '
        )
      end

      statusline.section_location = function()
        return '%2l:%-2v'
      end

      statusline.section_filename = function()
        local filename = vim.fn.expand '%:t'
        return filename == '' and '[No Name]' or filename
      end

      statusline.section_filetype = function()
        return vim.bo.filetype ~= '' and vim.bo.filetype or 'none'
      end

      statusline.active = function()
        local mode = statusline.section_mode {}
        local git = git_info()
        local filename = statusline.section_filename()
        local filetype = statusline.section_filetype()
        local loc = statusline.section_location()

        local left = table.concat(
          vim.tbl_filter(function(x)
            return x ~= ''
          end, { mode, git, filename }),
          ' | '
        )
        local right = table.concat(
          vim.tbl_filter(function(x)
            return x ~= ''
          end, { filetype, loc }),
          ' | '
        )
        return string.format('%s%s%s', left, '%=', right)
      end
    end,
  },
}
