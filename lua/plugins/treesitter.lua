-- nvim-treesitter — incremental parser system. Provides:
--   * Better syntax highlighting (semantic, not regex)
--   * Foundation for textobjects (vaf = around function, etc.)
--   * Foundation for treesitter-context (sticky function header)
--
-- Parsers are compiled native libraries. The `tree-sitter` CLI must be on PATH
-- (installed via `brew install tree-sitter-cli`).
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',                 -- v1 API
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      -- Tell treesitter that jsonc files should use the json parser
      -- (jsonc isn't a separate grammar; it's json with comments).
      vim.treesitter.language.register('json', 'jsonc')

      -- Parsers we want installed.
      local parsers = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline',
        'query', 'vim', 'vimdoc',
        'typescript', 'tsx', 'javascript', 'jsdoc',
        'python',
        'json', 'yaml', 'toml',
        'css', 'scss',
        'prisma', 'graphql',
        'dockerfile', 'gitignore', 'gitcommit', 'git_rebase', 'git_config',
        'regex', 'sql',
      }
      -- Install missing parsers in the background (async). First-time install
      -- runs on first launch only; afterwards everything is cached.
      require('nvim-treesitter').install(parsers)

      -- Enable highlight + indent on every supported filetype.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterEnable', { clear = true }),
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if lang and pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Smart textobjects driven by treesitter:
  --   vaf / vif   — around / inside function
  --   vac / vic   — around / inside class
  --   vaa / via   — around / inside parameter
  --   ]m / [m     — next / prev function start
  --   ]] / [[     — next / prev class start
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
        },
      }
      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'

      for _, m in ipairs {
        { 'af', '@function.outer', 'around function' },
        { 'if', '@function.inner', 'inside function' },
        { 'ac', '@class.outer',    'around class' },
        { 'ic', '@class.inner',    'inside class' },
        { 'aa', '@parameter.outer', 'around parameter' },
        { 'ia', '@parameter.inner', 'inside parameter' },
      } do
        vim.keymap.set({ 'x', 'o' }, m[1], function() select.select_textobject(m[2], 'textobjects') end, { desc = m[3] })
      end

      for _, j in ipairs {
        { ']m', 'next',     'start', '@function.outer', 'next function start' },
        { '[m', 'previous', 'start', '@function.outer', 'prev function start' },
        { ']M', 'next',     'end',   '@function.outer', 'next function end' },
        { '[M', 'previous', 'end',   '@function.outer', 'prev function end' },
        { ']]', 'next',     'start', '@class.outer',    'next class start' },
        { '[[', 'previous', 'start', '@class.outer',    'prev class start' },
      } do
        vim.keymap.set({ 'n', 'x', 'o' }, j[1], function()
          move['goto_' .. j[2] .. '_' .. j[3]](j[4], 'textobjects')
        end, { desc = j[5] })
      end
    end,
  },

  -- Sticky function/class header at the top of the buffer while you scroll past it.
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
      { '<leader>uC', '<cmd>TSContextToggle<cr>', desc = 'Toggle TS context header' },
    },
    opts = {
      enable = true,
      max_lines = 4,
      min_window_height = 20,
      line_numbers = true,
      multiline_threshold = 1,
      trim_scope = 'outer',
      mode = 'cursor',
    },
  },
}
