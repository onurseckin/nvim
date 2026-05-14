-- lualine.nvim — statusline at the bottom. Shows mode, branch, diagnostics,
-- file info, LSP servers, position.
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'echasnovski/mini.icons' },
  opts = {
    options = {
      theme = 'tokyonight',
      globalstatus = true,          -- one statusline for all splits
      section_separators = '',
      component_separators = '',
      disabled_filetypes = {
        statusline = { 'dashboard', 'alpha', 'snacks_dashboard' },
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = {
        { 'diagnostics', symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' } },
        { 'filename', path = 1, symbols = { modified = ' ●', readonly = ' ', unnamed = '[no name]' } },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if #clients == 0 then return '' end
            return ' ' .. table.concat(vim.tbl_map(function(c) return c.name end, clients), ',')
          end,
        },
        'encoding',
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
