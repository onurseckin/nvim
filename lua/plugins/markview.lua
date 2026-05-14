-- markview.nvim — in-buffer markdown rendering with hybrid mode (raw at cursor,
-- rendered everywhere else). Supports LaTeX math, HTML elements, inline images
-- (via snacks.image), footnotes, callouts.
--
--   <leader>tm   toggle rendering on/off
return {
  'OXY2DEV/markview.nvim',
  ft = { 'markdown', 'codecompanion', 'Avante' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.icons',
  },
  keys = {
    { '<leader>tm', '<cmd>Markview Toggle<cr>', desc = 'Toggle [m]arkdown render' },
  },
  opts = {
    preview = {
      modes = { 'n', 'no', 'c' },           -- render in normal, op-pending, command modes
      hybrid_modes = { 'i' },                -- raw rendering only in insert mode (hybrid)
      filetypes = { 'markdown', 'codecompanion', 'Avante' },
    },
    markdown = {
      headings = { shift_width = 0 },
    },
  },
}
