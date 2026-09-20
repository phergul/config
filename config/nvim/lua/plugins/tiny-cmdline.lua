return {
  'rachartier/tiny-cmdline.nvim',
  config = function()
    require('tiny-cmdline').setup {
      on_reposition = require('tiny-cmdline').adapters.blink,
    }
  end,
}
