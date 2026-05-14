-- Core editor options. Set BEFORE any plugin loads.

-- Leader keys (must be set before plugins so their keymaps register correctly).
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.have_nerd_font = true

local opt = vim.opt

-- Line numbers
opt.number = true              -- absolute number on cursor line
opt.relativenumber = true      -- relative on all others (jump with 5j, 12k, etc.)

-- Indentation (auto-detected per file by guess-indent and editorconfig)
opt.expandtab = true           -- tab key inserts spaces
opt.tabstop = 2                -- a real tab renders as 2 cols
opt.shiftwidth = 2             -- > / < shifts by 2
opt.smartindent = true

-- Search
opt.ignorecase = true          -- /foo matches Foo
opt.smartcase = true           -- ...unless you type /Foo (then case-sensitive)
opt.hlsearch = true            -- highlight matches (Esc clears via keymap)
opt.incsearch = true           -- search as you type

-- UI
opt.termguicolors = true       -- 24-bit color (required by modern colorschemes)
opt.signcolumn = 'yes'         -- always show sign column (prevents text jump when diagnostics appear)
opt.cursorline = true          -- highlight current line
opt.scrolloff = 8              -- keep 8 lines visible above/below cursor
opt.sidescrolloff = 8
opt.wrap = false               -- no line wrapping by default
opt.showmode = false           -- mode is shown in lualine, no need to duplicate
opt.cmdheight = 1
opt.pumheight = 12             -- popup menu max height (completion lists)
opt.fillchars = { eob = ' ' }  -- hide ~ on empty lines

-- Splits open in the natural place (right for vsplit, below for split)
opt.splitright = true
opt.splitbelow = true

-- Files
opt.undofile = true            -- persistent undo across sessions
opt.swapfile = false           -- no .swp files cluttering directories
opt.backup = false
opt.updatetime = 250           -- faster CursorHold (gitsigns/LSP rely on this)
opt.timeoutlen = 300           -- which-key popup delay

-- Clipboard: share with the OS (Cmd-C/Cmd-V work between nvim and other apps).
-- Scheduled after VimEnter to avoid slowing startup.
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Mouse works in all modes (useful even for power users for occasional clicks/resizes)
opt.mouse = 'a'

-- Diagnostics: virtual text on the right, plus signs in the gutter
vim.diagnostic.config {
  virtual_text = { spacing = 4, prefix = '●' },
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN]  = '',
      [vim.diagnostic.severity.INFO]  = '',
      [vim.diagnostic.severity.HINT]  = '',
    },
  },
}

-- Better completion experience: don't auto-select first item, don't insert as you type
opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }

-- Folding: treesitter-based, all open by default (we never want files folded on open)
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldenable = false         -- start unfolded
opt.foldlevel = 99
