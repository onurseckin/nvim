-- blink.cmp — folke's recommended completion engine. Faster than nvim-cmp,
-- written in Rust (with Lua API). Pulls suggestions from LSP, snippets, paths,
-- buffer words.
--
-- Snippets come from friendly-snippets (community-curated) via LuaSnip.
return {
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    version = 'v2.*',
    build = (vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0) and nil or 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',                -- stable release line
    dependencies = { 'L3MON4D3/LuaSnip', 'folke/lazydev.nvim' },
    opts = {
      keymap = {
        preset = 'default',          -- C-y accept, C-n/p navigate, C-e cancel, C-Space trigger
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },     -- show inline preview of next suggestion
        menu = { border = 'rounded' },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
          lazydev = {
            name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100,
          },
        },
      },
      snippets = { preset = 'luasnip' },
      signature = { enabled = true },        -- live signature help as you type args
    },
  },
}
