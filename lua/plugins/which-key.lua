-- which-key.nvim — your "always-available help."
--
-- Press <space> (leader) and wait ~300ms: which-key shows every binding under
-- that prefix. Press the next letter to drill into a group, or <esc> to close.
--
-- Group labels below give human-readable names to <leader>X prefixes.
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'modern',
    delay = 0,
    icons = {
      mappings = vim.g.have_nerd_font,
    },
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle / [T]erminal' },
      { '<leader>u', group = '[U]I toggle' },
      { '<leader>x', group = 'Diagnostics / Trouble' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>w', group = '[W]indow' },
      { '<leader>j', group = 'Harpoon [J]ump' },
      { '<leader>r', group = '[R]efactor / [R]eplace' },
      { '<leader>o', group = '[O]utline' },
      { '<leader>S', group = '[S]ession' },
      { '<leader>c', group = '[C]ode (LSP actions)' },
    },
  },
  keys = {
    { '<leader>?', function() require('which-key').show { global = false } end, desc = 'Buffer keymaps (which-key)' },
  },
}
