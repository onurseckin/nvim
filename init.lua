-- Entry point. Keep this file tiny.
-- Everything real lives under lua/config/ and lua/plugins/.

require 'config.options'   -- vim.opt.* settings + leader key
require 'config.keymaps'   -- non-plugin keymaps
require 'config.autocmds'  -- yank highlight, big files, etc.
require 'config.lazy'      -- bootstrap lazy.nvim and load lua/plugins/*
