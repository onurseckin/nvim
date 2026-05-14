-- Non-plugin keymaps. Plugin keymaps live in each plugin's own file.

local map = vim.keymap.set

-- Esc clears search highlight (much nicer than leaving it lit up)
map('n', '<Esc>', '<cmd>nohlsearch<cr>')

-- Exit terminal-mode with Esc Esc (so you can scroll/copy in the terminal split)
map('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- Diagnostic loclist
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Move focus between splits with Ctrl + hjkl (instead of Ctrl-w then hjkl)
map('n', '<C-h>', '<C-w>h', { desc = 'Move focus left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move focus down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move focus up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move focus right' })

-- Buffer navigation (power-user core: many open buffers, fast switching)
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })

-- Window splits (mirrors tmux split keys)
map('n', '<leader>w-', '<cmd>split<cr>',  { desc = 'Split horizontal' })
map('n', '<leader>w|', '<cmd>vsplit<cr>', { desc = 'Split vertical' })
map('n', '<leader>wd', '<cmd>close<cr>',  { desc = 'Close window' })
map('n', '<leader>wo', '<cmd>only<cr>',   { desc = 'Close others' })

-- Visual-mode indent: keep selection after <, > (so you can press them repeatedly)
map('v', '<', '<gv', { desc = 'Indent left (keep selection)' })
map('v', '>', '>gv', { desc = 'Indent right (keep selection)' })

-- Move selected lines up/down with J/K (visual mode only)
map('v', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Keep cursor centered when half-paging or jumping search results
map('n', '<C-d>', '<C-d>zz', { desc = 'Half-page down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half-page up (centered)' })
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search result (centered)' })

-- Keep yanked text when pasting over selection (don't replace the register with what was there)
map('x', 'p', [["_dP]], { desc = 'Paste without yanking selection' })
