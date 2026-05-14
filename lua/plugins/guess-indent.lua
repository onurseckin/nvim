-- guess-indent.nvim — auto-detects a file's indent style on open (tabs vs spaces,
-- width) so you don't have to fiddle with vim.opt. Modern replacement for
-- tpope/vim-sleuth. Kickstart bundles this by default.
return {
  'nmac427/guess-indent.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {},
}
