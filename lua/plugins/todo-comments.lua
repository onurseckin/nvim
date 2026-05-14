-- todo-comments.nvim — colorizes TODO/FIXME/HACK/NOTE/PERF/WARN/TEST keywords
-- in comments, and lets you fuzzy-search them across the project.
--
--   ]t / [t       next / prev todo
--   <leader>xt    Trouble panel with every todo (defined in trouble.lua)
--   <leader>st    Snacks picker for todos (defined in snacks.lua)
return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
  keys = {
    { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo' },
    { '[t', function() require('todo-comments').jump_prev() end, desc = 'Prev todo' },
  },
}
