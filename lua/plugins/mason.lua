-- mason.nvim — manages LSP server / formatter / linter installations.
-- Lives in its own file so `:Mason` works even from the dashboard before
-- any file is opened. The actual server setup happens in lsp.lua.
return {
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonLog', 'MasonUpdate', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll' },
    event = 'VeryLazy',
    opts = {
      ui = { border = 'rounded' },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cmd = {
      'MasonToolsInstall', 'MasonToolsInstallSync',
      'MasonToolsUpdate', 'MasonToolsUpdateSync',
      'MasonToolsClean',
    },
    -- mason-tool-installer's ensure_installed list lives in lsp.lua (so it
    -- stays next to the servers table). This entry just registers commands.
  },
}
