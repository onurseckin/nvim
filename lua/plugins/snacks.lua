-- snacks.nvim — folke's UI/UX mega-plugin. This single plugin replaces what
-- would otherwise be 7+ separate plugins: telescope, neo-tree/oil,
-- toggleterm, lazygit.nvim, image.nvim, indent-blankline, nvim-notify.
--
-- Modules are individually toggleable. Enable only what you'll use.
--
--   Snacks.picker       — fuzzy finder for files, grep, buffers, LSP refs, etc.
--   Snacks.explorer     — sidebar file tree (folders expand inline on <CR>)
--   Snacks.terminal     — floating/split terminal management
--   Snacks.lazygit      — opens lazygit in a managed floating window
--   Snacks.image        — inline PNG/SVG/PDF previews (WezTerm/Kitty)
--   Snacks.indent       — indent guides + scope highlight (replaces indent-blankline)
--   Snacks.notifier     — pretty top-right notifications
--   Snacks.dashboard    — startup screen
--   Snacks.scroll       — smooth scrolling
--   Snacks.words        — highlight other instances of word under cursor
--   Snacks.statuscolumn — git signs + line nr + folds in one gutter
--   Snacks.bufdelete    — close buffers without breaking window layout
--   Snacks.rename       — LSP-aware file rename (updates imports across project)
--   Snacks.scratch      — per-cwd scratch buffer
--   Snacks.zen          — distraction-free mode
--   Snacks.gitbrowse    — open current file/line on GitHub
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = { 'echasnovski/mini.icons' },
  opts = {
    -- Always-on background features
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = false },     -- no animation: power-user preference
      scope = { enabled = true },
    },
    scroll = { enabled = true },
    words = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
      style = 'compact',
    },
    input = { enabled = true },
    image = {
      enabled = true,
      doc = { enabled = true, inline = true, float = true },
    },

    -- Big features
    picker = {
      enabled = true,
      ui_select = true,
      layout = { preset = 'default' },
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    terminal = { enabled = true },
    lazygit = { enabled = true, configure = true },
    rename = { enabled = true },
    bufdelete = { enabled = true },
    scratch = { enabled = true },
    zen = { enabled = true },
    gitbrowse = { enabled = true },

    -- Startup dashboard (shown when nvim is opened without a file argument)
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File',     action = ':lua Snacks.picker.files()' },
          { icon = ' ', key = 'n', desc = 'New File',      action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text',     action = ':lua Snacks.picker.grep()' },
          { icon = ' ', key = 'r', desc = 'Recent Files',  action = ':lua Snacks.picker.recent()' },
          { icon = ' ', key = 'c', desc = 'Config',        action = ':lua Snacks.picker.files({ cwd = vim.fn.stdpath("config") })' },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy',          action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit',          action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
  },
  keys = {
    -- Search / picker (replaces telescope)
    { '<leader>sf',      function() Snacks.picker.files() end,            desc = '[S]earch [F]iles' },
    { '<leader>sg',      function() Snacks.picker.grep() end,             desc = '[S]earch by [G]rep' },
    { '<leader>sw',      function() Snacks.picker.grep_word() end,        desc = '[S]earch current [W]ord', mode = { 'n', 'x' } },
    { '<leader>sh',      function() Snacks.picker.help() end,             desc = '[S]earch [H]elp' },
    { '<leader>sk',      function() Snacks.picker.keymaps() end,          desc = '[S]earch [K]eymaps' },
    { '<leader>ss',      function() Snacks.picker.pickers() end,          desc = '[S]earch [S]nacks pickers (meta)' },
    { '<leader>sd',      function() Snacks.picker.diagnostics() end,      desc = '[S]earch [D]iagnostics' },
    { '<leader>sr',      function() Snacks.picker.resume() end,           desc = '[S]earch [R]esume' },
    { '<leader>s.',      function() Snacks.picker.recent() end,           desc = '[S]earch Recent files' },
    { '<leader><leader>', function() Snacks.picker.buffers() end,         desc = 'Recent buffers' },
    { '<leader>/',       function() Snacks.picker.lines() end,            desc = 'Fuzzy in current buffer' },
    { '<leader>s/',      function() Snacks.picker.grep_buffers() end,     desc = '[S]earch grep open buffers' },
    { '<leader>sn',      function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, desc = '[S]earch [N]eovim config' },
    { '<leader>su',      function() Snacks.picker.undo() end,             desc = '[S]earch [U]ndo history' },
    { '<leader>sc',      function() Snacks.picker.commands() end,         desc = '[S]earch [C]ommands' },
    { '<leader>sj',      function() Snacks.picker.jumps() end,            desc = '[S]earch [J]umps' },
    { '<leader>sm',      function() Snacks.picker.marks() end,            desc = '[S]earch [M]arks' },
    { '<leader>sR',      function() Snacks.picker.registers() end,        desc = '[S]earch [R]egisters' },
    { '<leader>sq',      function() Snacks.picker.qflist() end,           desc = '[S]earch [Q]uickfix' },
    { '<leader>sl',      function() Snacks.picker.loclist() end,          desc = '[S]earch [L]oclist' },
    { '<leader>st',      function() Snacks.picker.todo_comments() end,    desc = '[S]earch [T]odos' },

    -- Git pickers
    { '<leader>gs',      function() Snacks.picker.git_status() end,       desc = '[G]it [s]tatus' },
    { '<leader>gb',      function() Snacks.picker.git_branches() end,     desc = '[G]it [b]ranches' },
    { '<leader>gL',      function() Snacks.picker.git_log() end,          desc = '[G]it [L]og' },
    { '<leader>gT',      function() Snacks.picker.git_stash() end,        desc = '[G]it s[T]ash' },

    -- Lazygit
    { '<leader>gg',      function() Snacks.lazygit() end,                 desc = '[G]it: lazy[g]it' },
    { '<leader>gf',      function() Snacks.lazygit.log_file() end,        desc = '[G]it: lazygit current [f]ile log' },
    { '<leader>gB',      function() Snacks.gitbrowse() end,               desc = '[G]it: open in [B]rowser', mode = { 'n', 'v' } },

    -- Explorer
    { '<leader>e',       function() Snacks.explorer() end,                desc = '[E]xplorer toggle' },
    { '\\',              function() Snacks.explorer() end,                desc = 'Explorer toggle' },
    { '-',               function() Snacks.explorer.reveal() end,         desc = 'Explorer: reveal current file' },

    -- Terminal
    { '<C-\\>',          function() Snacks.terminal() end,                desc = 'Toggle terminal', mode = { 'n', 't' } },
    { '<leader>tf',      function() Snacks.terminal() end,                desc = '[T]erminal: [f]loat' },
    { '<leader>th',      function() Snacks.terminal(nil, { win = { position = 'bottom', height = 0.3 } }) end, desc = '[T]erminal: [h]orizontal' },
    { '<leader>tv',      function() Snacks.terminal(nil, { win = { position = 'right', width = 0.4 } }) end,  desc = '[T]erminal: [v]ertical' },

    -- Buffer
    { '<leader>bd',      function() Snacks.bufdelete() end,               desc = '[B]uffer [d]elete (keep layout)' },
    { '<leader>bo',      function() Snacks.bufdelete.other() end,         desc = '[B]uffer delete [o]thers' },

    -- File ops
    { '<leader>R',       function() Snacks.rename.rename_file() end,      desc = '[R]ename current file (LSP-aware)' },

    -- Misc UX
    { '<leader>.',       function() Snacks.scratch() end,                 desc = 'Scratch buffer (toggle)' },
    { '<leader>z',       function() Snacks.zen() end,                     desc = '[Z]en mode' },
    { '<leader>Z',       function() Snacks.zen.zoom() end,                desc = '[Z]en zoom (this split)' },
    { '<leader>n',       function() Snacks.notifier.show_history() end,   desc = '[N]otification history' },
    { '<leader>un',      function() Snacks.notifier.hide() end,           desc = 'Dismiss notifications' },

    -- LSP pickers via snacks (also bound per-buffer in lsp.lua when LSP attaches)
    { 'gO',              function() Snacks.picker.lsp_symbols() end,             desc = 'Document symbols' },
    { 'gW',              function() Snacks.picker.lsp_workspace_symbols() end,   desc = 'Workspace symbols' },
  },
  init = function()
    -- Bind UI toggles once snacks is loaded
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        Snacks.toggle.option('spell',          { name = 'Spelling' }):map('<leader>us')
        Snacks.toggle.option('wrap',           { name = 'Wrap' }):map('<leader>uw')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
        Snacks.toggle.diagnostics():map('<leader>ud')
        Snacks.toggle.line_number():map('<leader>ul')
        Snacks.toggle.treesitter():map('<leader>uT')
        Snacks.toggle.indent():map('<leader>ug')
        Snacks.toggle.inlay_hints():map('<leader>uh')
      end,
    })
  end,
}
