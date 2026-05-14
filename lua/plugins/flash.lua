-- flash.nvim — fuzzy-jump to any position visible on screen with 2-3 keys.
--
--   s{ab}   in normal/visual/operator-pending: jump to a 2-char match anywhere
--   S       jump by treesitter node
--   r       in operator-pending mode: remote action (e.g. dr{label} deletes a node elsewhere)
--
-- Note: vim's default `s` (substitute char) is replaced — use `cl` instead.
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  keys = {
    { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,             desc = 'Flash jump' },
    { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end,        desc = 'Flash treesitter' },
    { 'r', mode = 'o',               function() require('flash').remote() end,            desc = 'Flash remote' },
    { 'R', mode = { 'o', 'x' },      function() require('flash').treesitter_search() end, desc = 'Flash treesitter search' },
  },
}
