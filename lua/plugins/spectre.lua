-- nvim-spectre — project-wide find & replace with live preview.
--
--   <leader>rs   open Spectre (search box + replace box, project-wide)
--   <leader>rw   search current word across project
--   <leader>rf   search/replace inside current file only
return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = 'Spectre',
  keys = {
    { '<leader>rs', function() require('spectre').toggle() end,                              desc = '[R]eplace: [s]pectre' },
    { '<leader>rw', function() require('spectre').open_visual { select_word = true } end,    desc = '[R]eplace: current [w]ord' },
    { '<leader>rw', function() require('spectre').open_visual() end, mode = 'v',             desc = '[R]eplace: selection' },
    { '<leader>rf', function() require('spectre').open_file_search { select_word = true } end, desc = '[R]eplace: in [f]ile' },
  },
  opts = {
    open_cmd = 'noswapfile vnew',
    live_update = true,
  },
}
