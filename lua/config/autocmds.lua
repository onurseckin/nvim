-- Autocommands that don't belong to any specific plugin.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text briefly (visual confirmation that the yank happened)
autocmd('TextYankPost', {
  group = augroup('YankHighlight', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Remove trailing whitespace on save (silently)
autocmd('BufWritePre', {
  group = augroup('TrimTrailingWhitespace', { clear = true }),
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd [[silent! %s/\s\+$//e]]
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
  end,
})

-- Restore last cursor position when reopening a file
autocmd('BufReadPost', {
  group = augroup('RestoreCursor', { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-create parent directories on save (so `:e foo/bar/new.lua` + :w just works)
autocmd('BufWritePre', {
  group = augroup('AutoCreateDir', { clear = true }),
  callback = function(args)
    if args.match:match('^%w%w+:[\\/][\\/]') then return end  -- skip URIs
    vim.fn.mkdir(vim.fn.fnamemodify(args.file, ':p:h'), 'p')
  end,
})

-- Close some buffer types with just q (help, man, qf, etc.)
autocmd('FileType', {
  group = augroup('CloseWithQ', { clear = true }),
  pattern = { 'help', 'man', 'qf', 'lspinfo', 'startuptime', 'checkhealth', 'fugitive', 'git' },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = args.buf, silent = true })
  end,
})
