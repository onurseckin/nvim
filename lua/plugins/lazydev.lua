-- lazydev.nvim — makes the Lua LSP (lua_ls) aware of Neovim's runtime API and
-- your plugin code when you're editing the nvim config itself. Without this,
-- editing init.lua produces tons of false-positive diagnostics like "undefined
-- global vim". Only loads for .lua files.
return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'snacks.nvim',        words = { 'Snacks' } },
    },
  },
}
