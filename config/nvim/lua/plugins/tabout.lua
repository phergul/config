return {
  'abecodes/tabout.nvim',
  event = 'InsertEnter',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    tabkey = '<Tab>',
    backwards_tabkey = '<S-Tab>',
    act_as_tab = true, -- If not inside pairs, act as a real indentation tab
    enable_backwards = true,
    completion = false, -- Let blink handle the key mapping routing
    ignore_beginning = true,
  },
}
