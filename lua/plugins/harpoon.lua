-- harpoon (v2) — pin 1-9 files per project, jump instantly.
-- The 'killer feature' of modern nvim navigation.
--
--   <leader>a        add current file to the list
--   <leader>m        open the harpoon menu
--   <leader>j1..j9   jump directly to slot 1..9
--   <leader>jn / jp  next / prev in list
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = function()
    local h = require 'harpoon'
    local keys = {
      { '<leader>a',  function() h:list():add() end,                   desc = 'Harpoon: [a]dd file' },
      { '<leader>m',  function() h.ui:toggle_quick_menu(h:list()) end, desc = 'Harpoon: [m]enu' },
      { '<leader>jp', function() h:list():prev() end,                  desc = 'Harpoon: [p]rev' },
      { '<leader>jn', function() h:list():next() end,                  desc = 'Harpoon: [n]ext' },
    }
    for i = 1, 9 do
      table.insert(keys, {
        '<leader>j' .. i,
        function() h:list():select(i) end,
        desc = 'Harpoon: jump ' .. i,
      })
    end
    return keys
  end,
  config = function()
    require('harpoon'):setup {
      settings = { save_on_toggle = true, sync_on_ui_close = true },
    }
  end,
}
