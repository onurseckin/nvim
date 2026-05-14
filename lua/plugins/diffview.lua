-- diffview.nvim — full-window diff browser with file panel + side-by-side diffs.
-- Used for branch-level review (vs main, last commit, etc.) — gitsigns covers
-- per-line/hunk operations while editing.
--
--   <leader>gd   diff working tree vs HEAD (uncommitted changes)
--   <leader>gm   diff branch vs origin/main (what your branch added)
--   <leader>gp   diff working tree vs previous commit
--   <leader>gc   just the last commit's diff (HEAD~1..HEAD)
--   <leader>gh   file history (current file)
--   <leader>gH   branch history
--   <leader>gt   toggle the file panel (sidebar)
--   <leader>gD   close Diffview
return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = {
    'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles',
    'DiffviewFocusFiles', 'DiffviewRefresh', 'DiffviewFileHistory',
  },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>',                       desc = 'Diff working tree vs HEAD' },
    { '<leader>gD', '<cmd>DiffviewClose<cr>',                      desc = 'Close Diffview' },
    { '<leader>gm', '<cmd>DiffviewOpen origin/main...HEAD<cr>',    desc = 'Diff branch vs main' },
    { '<leader>gp', '<cmd>DiffviewOpen HEAD~1<cr>',                desc = 'Diff vs previous commit' },
    { '<leader>gc', '<cmd>DiffviewOpen HEAD~1..HEAD<cr>',          desc = 'Last commit only' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>',              desc = 'File history (current file)' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>',                desc = 'Branch history' },
    { '<leader>gt', '<cmd>DiffviewToggleFiles<cr>',                desc = 'Toggle file panel' },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { layout = 'diff2_horizontal' },
      merge_tool = { layout = 'diff3_horizontal' },
      file_history = { layout = 'diff2_horizontal' },
    },
    file_panel = {
      listing_style = 'tree',
      win_config = { position = 'left', width = 35 },
    },
  },
  config = function(_, opts)
    require('diffview').setup(opts)

    -- Per-file fold strategy in Diffview:
    --   lock files (bun.lock, package-lock.json, etc.) → foldlevel=0 (only show changes)
    --   everything else                                → foldlevel=3 (most of file visible)
    local lock_basenames = {
      ['bun.lock'] = true, ['bun.lockb'] = true,
      ['package-lock.json'] = true, ['pnpm-lock.yaml'] = true, ['yarn.lock'] = true,
      ['Cargo.lock'] = true, ['poetry.lock'] = true, ['Pipfile.lock'] = true,
      ['composer.lock'] = true, ['Gemfile.lock'] = true,
      ['go.sum'] = true, ['mix.lock'] = true, ['flake.lock'] = true,
    }
    local function is_lock_file(path)
      local base = path:match('([^/]+)$') or ''
      if lock_basenames[base] then return true end
      return base:match('%.lock$') or base:match('%.lockb$') or base:match('%.tsbuildinfo$')
    end

    vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
      group = vim.api.nvim_create_augroup('DiffviewFolds', { clear = true }),
      callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        if not (bufname:match('^diffview://') or vim.bo[args.buf].filetype:match('Diffview')) then
          return
        end
        vim.wo.foldenable = true
        vim.wo.foldlevel = is_lock_file(bufname) and 0 or 3
      end,
    })
  end,
}
