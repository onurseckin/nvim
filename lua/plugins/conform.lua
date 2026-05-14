-- conform.nvim — runs the right formatter for each filetype on save.
--
--   * TS/JS/TSX/JSON/YAML/Markdown/CSS → prettierd (or prettier as fallback)
--   * Python                            → ruff_format + organize imports
--   * Lua                               → stylua
--
-- Mason installs the binaries; conform finds them on PATH.
-- Format manually with <leader>f.
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true, lsp_format = 'fallback' } end,
      mode = { 'n', 'v' },
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Skip filetypes that don't have a standardized formatter (or you don't want auto-format for)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
      return { timeout_ms = 1000, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'ruff_organize_imports' },

      javascript        = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact   = { 'prettierd', 'prettier', stop_after_first = true },
      typescript        = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact   = { 'prettierd', 'prettier', stop_after_first = true },
      vue               = { 'prettierd', 'prettier', stop_after_first = true },
      css               = { 'prettierd', 'prettier', stop_after_first = true },
      scss              = { 'prettierd', 'prettier', stop_after_first = true },
      html              = { 'prettierd', 'prettier', stop_after_first = true },
      json              = { 'prettierd', 'prettier', stop_after_first = true },
      jsonc             = { 'prettierd', 'prettier', stop_after_first = true },
      yaml              = { 'prettierd', 'prettier', stop_after_first = true },
      markdown          = { 'prettierd', 'prettier', stop_after_first = true },
      graphql           = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
