-- gitsigns.nvim — inline git change markers in the gutter and hunk operations.
--
--   ]c / [c       jump to next / prev hunk
--   <leader>hs    stage the hunk under cursor (or visual selection)
--   <leader>hr    reset the hunk
--   <leader>hp    preview hunk in floating window
--   <leader>hb    blame current line (full message in float)
--   <leader>hd    diffthis (vs index)
--   <leader>hD    diffthis vs HEAD (= last commit)
--   <leader>tb    toggle inline blame virtual text
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    on_attach = function(bufnr)
      local gs = require 'gitsigns'
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map('n', ']c', function()
        if vim.wo.diff then vim.cmd.normal { ']c', bang = true } else gs.nav_hunk 'next' end
      end, 'Next git change')
      map('n', '[c', function()
        if vim.wo.diff then vim.cmd.normal { '[c', bang = true } else gs.nav_hunk 'prev' end
      end, 'Prev git change')

      map({ 'n', 'v' }, '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Stage hunk')
      map({ 'n', 'v' }, '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Reset hunk')
      map('n', '<leader>hS', gs.stage_buffer,          'Stage buffer')
      map('n', '<leader>hR', gs.reset_buffer,          'Reset buffer')
      map('n', '<leader>hp', gs.preview_hunk,          'Preview hunk')
      map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Blame line (full)')
      map('n', '<leader>hd', gs.diffthis,              'Diff vs index')
      map('n', '<leader>hD', function() gs.diffthis '@' end, 'Diff vs HEAD')
      map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle inline blame')
    end,
  },
}
