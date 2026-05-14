-- persistence.nvim — auto-saves a session per cwd. Reopen a repo with
-- <leader>Ss and your buffers, splits, harpoon list, and layout return.
--
--   <leader>Ss   restore session for current cwd
--   <leader>Sl   restore the last session (regardless of cwd)
--   <leader>Sd   don't save current session on exit (useful when experimenting)
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp' },
  },
  keys = {
    { '<leader>Ss', function() require('persistence').load() end,            desc = 'Restore session for cwd' },
    { '<leader>Sl', function() require('persistence').load { last = true } end, desc = 'Restore last session' },
    { '<leader>Sd', function() require('persistence').stop() end,            desc = "Don't save current session" },
  },
}
