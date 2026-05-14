-- Bootstraps lazy.nvim (the plugin manager) and loads every file under lua/plugins/.
-- Each plugin file under lua/plugins/<name>.lua must return a single lazy.nvim spec.

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- Install lazy.nvim if it isn't already on disk
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system {
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Failed to clone lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

-- The `{ import = 'plugins' }` line tells lazy to scan lua/plugins/*.lua and load each
-- file's returned spec automatically. Adding a new plugin = adding a new file there.
require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  install = { colorscheme = { 'tokyonight', 'habamax' } },
  checker = { enabled = false },          -- don't auto-check for plugin updates
  change_detection = { notify = false },  -- silent reload when config files change
  ui = {
    border = 'rounded',
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
      keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
      source = '📄', start = '🚀', task = '📌',
    },
  },
  performance = {
    rtp = {
      -- Disable vim builtins we don't use, for faster startup
      disabled_plugins = {
        'gzip', 'matchit', 'matchparen', 'netrwPlugin',
        'tarPlugin', 'tohtml', 'tutor', 'zipPlugin',
      },
    },
  },
})
