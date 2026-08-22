return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      enabled = true,
      render_modes = { 'n', 'c', 't' },
      preset = 'none',
      max_file_size = 10.0,
      file_types = { 'markdown' },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
}
