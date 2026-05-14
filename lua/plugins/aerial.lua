-- aerial.nvim — symbol outline sidebar (functions/classes/variables in current file).
-- Useful in long files. Backed by treesitter or LSP, whichever is available.
--
--   <leader>oo   toggle outline on the right
--   <leader>on   floating nav popup
--   {  / }       prev / next symbol (when in aerial buffer)
return {
  'stevearc/aerial.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
  cmd = { 'AerialToggle', 'AerialOpen', 'AerialNavToggle' },
  keys = {
    { '<leader>oo', '<cmd>AerialToggle!<cr>',  desc = '[O]utline: toggle' },
    { '<leader>on', '<cmd>AerialNavToggle<cr>', desc = '[O]utline: [n]av popup' },
  },
  opts = {
    backends = { 'treesitter', 'lsp', 'markdown', 'man' },
    layout = {
      max_width = { 40, 0.3 },
      min_width = 25,
      default_direction = 'right',
      placement = 'edge',
    },
    attach_mode = 'window',
    show_guides = true,
    autojump = true,
    on_attach = function(bufnr)
      vim.keymap.set('n', '{', '<cmd>AerialPrev<cr>', { buffer = bufnr, desc = 'Aerial prev' })
      vim.keymap.set('n', '}', '<cmd>AerialNext<cr>', { buffer = bufnr, desc = 'Aerial next' })
    end,
  },
}
