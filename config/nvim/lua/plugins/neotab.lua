return {
  'kawre/neotab.nvim',
  -- Initialize before blink's Tab mapping can call neotab.
  lazy = false,
  opts = {
    -- blink.cmp owns these keys and delegates here after completion/snippets.
    tabkey = '',
    reverse_key = '',
    act_as_tab = true,
    behavior = 'nested',
  },
}
