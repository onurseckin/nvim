-- trouble.nvim — pretty list for diagnostics, references, symbols, quickfix, todos.
-- Better than the built-in quickfix for these specific use cases.
--
--   <leader>xx   workspace diagnostics
--   <leader>xX   buffer diagnostics
--   <leader>xs   symbols panel (split)
--   <leader>xl   LSP refs / impls in right split
--   <leader>xL   loclist
--   <leader>xQ   quickfix
--   <leader>xt   todo comments
return {
  'folke/trouble.nvim',
  dependencies = { 'echasnovski/mini.icons' },
  cmd = 'Trouble',
  opts = { focus = true, auto_close = true },
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',                       desc = 'Workspace diagnostics' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',          desc = 'Buffer diagnostics' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>',               desc = 'Symbols panel' },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP refs/impls' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                           desc = 'Location list' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>',                            desc = 'Quickfix list' },
    { '<leader>xt', '<cmd>Trouble todo toggle<cr>',                              desc = 'Todo comments' },
  },
}
