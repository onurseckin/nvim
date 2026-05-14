-- debugprint.nvim — single-keystroke "console.log" for the variable under
-- cursor (or any expression you type). Works in 30+ languages.
--
--   g?p   print value of variable below the current line
--   g?P   print value above the current line
--   g?o   "plain" print line (no var) below
--   g?O   plain print above
--   g?v   in visual mode: print the selection
--   g?V   visual, above
--
-- Example: cursor on `user` in `const user = useAuth()`, press `g?p`, get:
--   const user = useAuth()
--   console.warn('DEBUGPRINT[1]: page.tsx:42: user=', user)
return {
  'andrewferrier/debugprint.nvim',
  event = 'BufReadPre',
  opts = {
    keymaps = {
      normal = {
        plain_below = 'g?o',
        plain_above = 'g?O',
        variable_below = 'g?p',
        variable_above = 'g?P',
        variable_below_alwaysprompt = 'g?ip',
        variable_above_alwaysprompt = 'g?iP',
        textobj_below = 'g?go',
        textobj_above = 'g?gO',
        toggle_comment_debug_prints = 'g?t',
        delete_debug_prints = 'g?d',
      },
      visual = {
        variable_below = 'g?v',
        variable_above = 'g?V',
      },
    },
    commands = {
      toggle_comment_debug_prints = 'ToggleCommentDebugPrints',
      delete_debug_prints = 'DeleteDebugPrints',
    },
  },
  cmd = { 'ToggleCommentDebugPrints', 'DeleteDebugPrints' },
}
