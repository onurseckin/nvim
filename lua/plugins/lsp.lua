-- LSP (Language Server Protocol) setup.
--
-- Architecture:
--   mason.nvim                — downloads LSP servers + formatters into ~/.local/share/nvim/mason
--   mason-lspconfig.nvim      — bridges Mason package names to lspconfig server names
--   mason-tool-installer.nvim — auto-installs the list below on first launch
--   nvim-lspconfig            — actually starts the servers and attaches them to buffers
--
-- The `servers` table is the single source of truth. Add a server name and
-- optional settings; mason-tool-installer downloads it and lspconfig wires it
-- to the appropriate filetypes.
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },     -- LSP progress in bottom-right
    'saghen/blink.cmp',                     -- adds completion capabilities below
  },
  config = function()
    -- Per-buffer LSP keymaps fire when an LSP attaches to the buffer.
    -- (Buffer-scoped, not global — so they only exist where they make sense.)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, 'Rename symbol')
        map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
        map('grd', function() Snacks.picker.lsp_definitions() end, 'Goto definition')
        map('grr', function() Snacks.picker.lsp_references() end, 'Goto references')
        map('gri', function() Snacks.picker.lsp_implementations() end, 'Goto implementation')
        map('grt', function() Snacks.picker.lsp_type_definitions() end, 'Goto type definition')
        map('grD', vim.lsp.buf.declaration, 'Goto declaration')
        map('gO', function() Snacks.picker.lsp_symbols() end, 'Document symbols')
        map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Workspace symbols')
        map('K', vim.lsp.buf.hover, 'Hover docs')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature help', 'i')

        -- Highlight references to the symbol under the cursor (clear on cursor move).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight = vim.api.nvim_create_augroup('UserLspHighlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf, group = highlight, callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf, group = highlight, callback = vim.lsp.buf.clear_references,
          })
        end

        -- Inlay hints toggle (modern LSP feature: shows parameter names, types inline)
        if client and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
        end
      end,
    })

    -- Completion capabilities from blink.cmp — tells LSP servers we support
    -- snippets, additional textEdits, etc.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- ─── Language servers ─────────────────────────────────────────────────
    -- Each entry maps a server name (as known to lspconfig) to its settings.
    -- Empty table = use defaults.
    local servers = {
      -- Lua: for editing this config itself.
      lua_ls = {
        settings = {
          Lua = { completion = { callSnippet = 'Replace' } },
        },
      },
      -- TypeScript / JavaScript / React / Next / NestJS
      vtsls = {},
      eslint = {},
      tailwindcss = {
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
      },
      -- Python / FastAPI
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'standard',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
            },
          },
        },
      },
      ruff = { init_options = { settings = { logLevel = 'error' } } },
      -- Database / schema
      prismals = {},
      -- Config / markup / shell
      jsonls = {},
      yamlls = {},
      taplo = {},      -- TOML (pyproject.toml etc.)
      bashls = {},
      marksman = {},   -- Markdown
      dockerls = {},
    }

    -- Things that Mason should keep installed (LSPs + formatters).
    -- LSP names come from the `servers` table above; the rest are listed explicitly.
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
      'stylua',     -- Lua formatter
      'prettierd',  -- TS/JS/JSON/YAML/Markdown formatter (daemonized, fast)
      'prettier',   -- fallback when prettierd isn't available
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Hand each server's setup to lspconfig, merging in our capabilities.
    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
