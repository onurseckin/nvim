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

        -- TypeScript-specific code actions (work via vtsls). They no-op gracefully
        -- on non-TS buffers since vtsls won't be the active client there.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == 'vtsls' then
          local function ts_action(name, source)
            return function()
              client:exec_cmd({
                title = name,
                command = 'typescript.' .. source,
                arguments = { vim.api.nvim_buf_get_name(0) },
              })
            end
          end
          map('<leader>co', ts_action('Organize Imports', 'organizeImports'), '[C]ode: [o]rganize imports')
          map('<leader>cM', ts_action('Add Missing Imports', 'addMissingImports'), '[C]ode: add [M]issing imports')
          map('<leader>cu', ts_action('Remove Unused', 'removeUnused'), '[C]ode: remove [u]nused')
          map('<leader>cF', ts_action('Fix All', 'fixAll'), '[C]ode: [F]ix all')
        end
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

    -- Silence the harmless but spammy "Command setContext not found" / etc.
    -- These come from VSCode-extension LSPs (vtsls, tailwindcss, eslint) that
    -- send VSCode-specific context updates Neovim doesn't implement.
    -- The no-op handler keeps the log clean without affecting functionality.
    for _, cmd in ipairs {
      'setContext', '_typescript.setContext',
      'editor.action.triggerSuggest', 'editor.action.triggerParameterHints',
      'workbench.action.openSettings',
    } do
      vim.lsp.commands[cmd] = function() end
    end

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
      -- TypeScript / JavaScript / React / Next / NestJS.
      -- Defaults are tuned for medium projects; proxai_nest hits the 3 GB cap.
      -- Bumping maxTsServerMemory to 8 GB + suppressing autoImports' workspace
      -- scan eliminates the SIGABRT crash loop on large monorepos.
      vtsls = {
        settings = {
          typescript = {
            tsserver = {
              maxTsServerMemory = 8192,   -- 8 GB (default 3072)
            },
            preferences = {
              includePackageJsonAutoImports = 'auto',  -- not 'on' (less workspace scanning)
            },
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = { completeFunctionCalls = true },
          },
          javascript = {
            preferences = { includePackageJsonAutoImports = 'auto' },
          },
          vtsls = {
            autoUseWorkspaceTsdk = true,  -- use the project's TS, not bundled
            experimental = {
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
        },
      },
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
      sqls = {
        -- sqls (Go-based). Faster + lower memory than the Node alternative.
        -- Supports Postgres, MySQL, SQLite. Per-project connection details
        -- live in ~/.config/sqls/config.yml. Without a config you still get
        -- syntax, hover, completion, formatting.
        settings = {
          sqls = {
            connections = {},   -- add per-project DB connections here when needed
          },
        },
      },

      -- Config / markup / shell
      jsonls = {
        on_new_config = function(new_config)
          -- Hand jsonls the full SchemaStore catalog (tsconfig, package.json,
          -- .eslintrc, .prettierrc, etc.)
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
        end,
        settings = {
          json = {
            validate = { enable = true },
            format = { enable = true },
          },
        },
      },
      yamlls = {
        on_new_config = function(new_config)
          -- Same for yamlls — GitHub Actions, docker-compose, k8s, OpenAPI, etc.
          new_config.settings.yaml.schemas = vim.tbl_deep_extend(
            'force',
            new_config.settings.yaml.schemas or {},
            require('schemastore').yaml.schemas()
          )
        end,
        settings = {
          yaml = {
            schemaStore = {
              -- We pull schemas via schemastore.nvim, so disable yamlls's own fetcher.
              enable = false,
              url = '',
            },
            validate = true,
            keyOrdering = false,           -- don't complain about un-alphabetized keys
          },
        },
      },
      taplo = {},                          -- TOML (pyproject.toml, Cargo.toml, etc.)
      bashls = {},
      marksman = {},                       -- Markdown
      dockerls = {},                       -- Dockerfile
      docker_compose_language_service = {},-- docker-compose.yml (separate from dockerls)
      helm_ls = {},                        -- Kubernetes Helm charts
    }

    -- Things that Mason should keep installed (LSPs + formatters).
    -- LSP names come from the `servers` table above; the rest are listed explicitly.
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, {
      'stylua',     -- Lua formatter
      'prettierd',  -- TS/JS/JSON/YAML/Markdown formatter (daemonized, fast)
      'prettier',   -- fallback when prettierd isn't available
      'sqlfluff',   -- SQL linter + formatter (multi-dialect incl. Postgres)
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
