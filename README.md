# nvim

Personal Neovim configuration. Modular, snacks-based, power-user oriented.

Lives at `~/.config/nvim`.

## What this is

A fresh, hand-written Neovim config built around **[snacks.nvim](https://github.com/folke/snacks.nvim)** (folke's UI/UX mega-plugin). The stack favors stability, speed, and visibility over feature breadth — every plugin earns its keep, every keybinding has a clear purpose.

No AI plugins. Just an editor.

## File layout

```
~/.config/nvim/
├── init.lua                       # entry point (tiny — just requires below)
├── lua/
│   ├── config/
│   │   ├── options.lua            # vim.opt.* + leader key
│   │   ├── keymaps.lua            # non-plugin keymaps (buffer/window/edit)
│   │   ├── autocmds.lua           # yank highlight, trim whitespace, etc.
│   │   └── lazy.lua               # bootstraps lazy.nvim, loads lua/plugins/*
│   └── plugins/                   # one file per plugin (or tight cluster)
│       ├── colorscheme.lua        # tokyonight (folke)
│       ├── mini-icons.lua         # icons used by everything
│       ├── snacks.lua             # ★ folke's mega-plugin (~7 plugins-in-one)
│       ├── which-key.lua          # press <space> + wait → see what's bound
│       ├── treesitter.lua         # syntax + textobjects + sticky context
│       ├── lsp.lua                # mason + lspconfig + per-language servers
│       ├── completion.lua         # blink.cmp + LuaSnip + friendly-snippets
│       ├── conform.lua            # formatters (prettier, ruff, stylua, ...)
│       ├── lazydev.lua            # makes lua_ls understand the nvim API
│       ├── gitsigns.lua           # inline git change markers + hunk ops
│       ├── diffview.lua           # branch/commit diff browser
│       ├── harpoon.lua            # pin files, jump instantly
│       ├── flash.lua              # 2-char jump to anywhere on screen
│       ├── editing.lua            # surround + ts-autotag
│       ├── spectre.lua            # project-wide find/replace
│       ├── aerial.lua             # symbol outline sidebar
│       ├── persistence.lua        # session per cwd
│       ├── trouble.lua            # pretty diagnostics list
│       ├── todo-comments.lua      # TODO/FIXME highlighting + search
│       ├── markview.lua           # in-buffer markdown rendering
│       ├── colorizer.lua          # inline hex/rgb/Tailwind color swatches
│       └── lualine.lua            # statusline
├── stylua.toml                    # formatter config for this lua code
├── lazy-lock.json                 # plugin version lock (committed)
└── .gitignore
```

Adding a new plugin = adding a new file in `lua/plugins/`. Lazy auto-discovers it.

## Required external tools

These must be installed on your system (`brew install` on macOS):

| Tool | Why |
|---|---|
| `neovim` >= 0.12 | The editor itself |
| `git` | Lazy clones plugins, gitsigns uses it |
| `ripgrep` (`rg`) | snacks.picker.grep |
| `fd` | Faster file finding |
| `fzf` | Telescope-style fuzzy matching |
| `tree-sitter-cli` | Compiles treesitter parsers |
| `lazygit` | `<leader>gg` opens it |
| `node` | Runs many language servers |
| `imagemagick` (`magick`) | snacks.image SVG/PDF conversion |

On first launch of nvim, **Mason** auto-installs all the LSPs and formatters into `~/.local/share/nvim/mason/`.

## Plugin glossary

### Infrastructure

| Plugin | Role |
|---|---|
| **lazy.nvim** | Plugin manager. Lazy-loads plugins, caches them, tracks updates. |
| **mason.nvim** + bridges | Installer/manager for LSP servers and formatters. Run `:Mason` to inspect. |
| **nvim-lspconfig** | The actual LSP client setup. |
| **blink.cmp** | Completion engine (Rust-backed). Faster than nvim-cmp. |
| **LuaSnip** + **friendly-snippets** | Snippet engine + a big community snippet pack. |
| **conform.nvim** | Format-on-save dispatcher (prettier/ruff/stylua per filetype). |
| **lazydev.nvim** | Makes editing `lua/` files type-aware (vim API + plugin types). |
| **nvim-treesitter** (+ textobjects, context) | Semantic syntax parsing. Powers highlighting, text objects, sticky function header. |
| **mini.icons** | Icon set. Used by snacks, lualine. |

### Folke stack (one plugin, many features)

**snacks.nvim** provides all of:

| Module | What it does | Replaces |
|---|---|---|
| `Snacks.picker` | Fuzzy file/grep/buffer/symbols/LSP picker | telescope |
| `Snacks.explorer` | Sidebar file tree (folders expand inline on `<CR>`) | neo-tree/nvim-tree |
| `Snacks.terminal` | Floating/split terminal | toggleterm |
| `Snacks.lazygit` | Launches lazygit in a managed float | lazygit.nvim |
| `Snacks.image` | Inline PNG/SVG/PDF previews | image.nvim |
| `Snacks.indent` | Indent guides + scope highlight | indent-blankline |
| `Snacks.notifier` | Top-right notifications | nvim-notify |
| `Snacks.dashboard` | Startup screen | alpha-nvim |
| `Snacks.statuscolumn` | Git signs + line nr + folds in one gutter | — |
| `Snacks.scroll` | Smooth scrolling | — |
| `Snacks.words` | Highlight other instances of word under cursor | vim-illuminate |
| `Snacks.bufdelete` | Close buffer without breaking window layout | mini.bufremove |
| `Snacks.rename` | LSP-aware file rename (updates imports) | — |
| `Snacks.scratch` | Per-cwd scratch buffer | — |
| `Snacks.zen` | Distraction-free mode | zen-mode |
| `Snacks.gitbrowse` | Open current file/line on GitHub | gitlinker |

### Git

| Plugin | Role |
|---|---|
| **gitsigns.nvim** | Inline `+/~/-` gutter, hunk stage/preview/blame |
| **diffview.nvim** | Full-window branch/commit diff browser with file panel |

### Editing power tools

| Plugin | Role |
|---|---|
| **harpoon (v2)** | Pin 1–9 files per project, jump instantly. The killer feature. |
| **flash.nvim** | `s{ab}` → jump to any visible 2-char target |
| **nvim-surround** | `ysiw"`, `cs"'`, `ds"` — surround motions |
| **nvim-ts-autotag** | Auto-close + auto-rename JSX/TSX/HTML tags |
| **nvim-spectre** | Project-wide find/replace with live preview |
| **aerial.nvim** | Symbol outline sidebar |
| **trouble.nvim** | Pretty diagnostics/refs/todos panel |
| **todo-comments.nvim** | Highlight + search TODO/FIXME/HACK/NOTE/PERF |
| **persistence.nvim** | Session-per-cwd (restore buffers/splits/layout) |

### Visual / Markdown

| Plugin | Role |
|---|---|
| **tokyonight.nvim** | Colorscheme (folke). `night` variant. |
| **lualine.nvim** | Statusline at the bottom |
| **markview.nvim** | In-buffer markdown rendering with hybrid mode |
| **nvim-colorizer.lua** | Inline hex/rgb/hsl/Tailwind color swatches |
| **which-key.nvim** | Live keybinding discovery (press `<space>` + wait) |

## Keybindings

**Leader = `<space>`.** Press space and wait — which-key tells you everything.

### Search & navigation (snacks.picker)

| Key | Action |
|---|---|
| `<space><space>` | recent buffers (sorted by use) — primary file switcher |
| `<space>sf` | find files |
| `<space>sg` | live grep |
| `<space>sw` | grep current word |
| `<space>s.` | recent files |
| `<space>/` | fuzzy in current buffer |
| `<space>s/` | grep open buffers |
| `<space>sh` | help tags |
| `<space>sk` | keymaps |
| `<space>sc` | commands |
| `<space>sj` | jumps |
| `<space>sm` | marks |
| `<space>sn` | nvim config files |
| `<space>su` | undo history |
| `<space>st` | todo comments |

### File tree & filesystem

| Key | Action |
|---|---|
| `\` | toggle Snacks.explorer (sidebar tree) |
| `<space>e` | toggle explorer |
| `-` | reveal current file in explorer |

### Buffers & windows

| Key | Action |
|---|---|
| `<S-h>` / `<S-l>` | prev / next buffer |
| `<space>bd` | delete buffer (keep window layout) |
| `<space>bo` | delete other buffers |
| `<space>w-` / `<space>w\|` | split horizontal / vertical |
| `<C-h/j/k/l>` | move between splits |
| `<space>wd` / `<space>wo` | close window / close others |

### Harpoon (pinned files)

| Key | Action |
|---|---|
| `<space>a` | add current file to pin list |
| `<space>m` | open harpoon menu |
| `<space>j1`–`j9` | jump to slot 1–9 |
| `<space>jn` / `<space>jp` | next / prev pinned |

### Git

| Key | Action |
|---|---|
| `<space>gg` | lazygit |
| `<space>gf` | lazygit log for current file |
| `<space>gs` | git status picker |
| `<space>gb` | git branches picker |
| `<space>gL` | git log picker |
| `<space>gT` | git stash picker |
| `<space>gB` | open file in browser (GitHub) |
| `<space>gd` | diffview: working tree vs HEAD |
| `<space>gm` | diffview: branch vs main |
| `<space>gp` | diffview: vs previous commit |
| `<space>gc` | diffview: last commit only |
| `<space>gh` | file history (current file) |
| `<space>gH` | branch history |
| `<space>gt` | toggle diffview file panel |
| `<space>gD` | close diffview |
| `]c` / `[c` | next / prev hunk |
| `<space>hs` / `<space>hr` | stage / reset hunk |
| `<space>hp` | preview hunk |
| `<space>hb` | blame line (full message) |
| `<space>tb` | toggle inline blame virtual text |

### LSP (per-buffer, set on LspAttach)

| Key | Action |
|---|---|
| `grd` | go to definition |
| `grr` | references |
| `gri` | implementations |
| `grt` | type definition |
| `grD` | declaration |
| `grn` | rename symbol |
| `gra` | code action |
| `K` | hover docs |
| `gO` / `gW` | document / workspace symbols |

### Editing

| Key | Action |
|---|---|
| `s{ab}` | flash jump to 2-char target |
| `S` | flash jump by treesitter node |
| `ysiw"` / `cs"'` / `ds"` | surround word / change / delete |
| `vaf` / `vif` | around / inside function |
| `vac` / `vic` | around / inside class |
| `]m` / `[m` | next / prev function |
| `<space>f` | format buffer |
| `<space>R` | rename current file (LSP-aware) |
| visual `J` / `K` | move selection down / up |
| visual `<` / `>` | indent, keep selection |
| `<space>.` | toggle scratch buffer |

### Diagnostics / Trouble

| Key | Action |
|---|---|
| `<space>xx` | workspace diagnostics |
| `<space>xX` | buffer diagnostics |
| `<space>xs` | symbols panel |
| `<space>xl` | LSP refs/impls |
| `<space>xt` | todo comments |
| `]d` / `[d` | next / prev diagnostic |
| `]t` / `[t` | next / prev todo |

### Terminal

| Key | Action |
|---|---|
| `<C-\>` | toggle floating terminal |
| `<space>tf` / `th` / `tv` | float / horizontal / vertical |
| `<esc><esc>` | exit terminal-mode |

### Refactor / Replace

| Key | Action |
|---|---|
| `<space>rs` | Spectre: project-wide find/replace |
| `<space>rw` | Spectre: replace current word |
| `<space>rf` | Spectre: replace in current file |

### Outline / Markdown

| Key | Action |
|---|---|
| `<space>oo` | aerial outline (right sidebar) |
| `<space>on` | aerial nav popup |
| `<space>tm` | toggle markview rendering |
| `<space>tM` | toggle markdown browser preview (if installed) |

### Session

| Key | Action |
|---|---|
| `<space>Ss` | restore session for cwd |
| `<space>Sl` | restore last session |
| `<space>Sd` | don't save current session |

### UI toggles

| Key | Action |
|---|---|
| `<space>us` | spell |
| `<space>uw` | wrap |
| `<space>ul` | line numbers |
| `<space>uL` | relative line numbers |
| `<space>ud` | diagnostics |
| `<space>uT` | treesitter |
| `<space>ug` | indent guides |
| `<space>uh` | inlay hints |

### Misc

| Key | Action |
|---|---|
| `<space>z` | zen mode |
| `<space>Z` | zen zoom (just this split) |
| `<space>n` | notification history |
| `<space>?` | which-key for buffer-local maps |
| `<space>q` | open diagnostic quickfix |

## Adding a plugin

1. Create `lua/plugins/<name>.lua`:
   ```lua
   return {
     'author/repo',
     event = 'VeryLazy',
     opts = {},
     keys = {
       { '<leader>x', '<cmd>SomeCommand<cr>', desc = 'Description' },
     },
   }
   ```
2. Restart nvim. lazy.nvim auto-installs it.
3. Add a which-key group label in `lua/plugins/which-key.lua` if you use a new prefix.

## Removing a plugin

1. Delete the `lua/plugins/<name>.lua` file
2. Restart nvim. Lazy.nvim cleans the plugin from `~/.local/share/nvim/lazy/` automatically.

## Updating

```vim
:Lazy update         " update all plugins
:Lazy sync           " update + clean orphans + lock file
:Mason               " update LSP servers
:checkhealth         " diagnose anything broken
```

## License

MIT. Use however you like.
