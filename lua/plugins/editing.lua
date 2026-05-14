-- Editing primitives: surround motions + autotag for JSX/HTML.
return {
  -- Surround motions: ysiw" wraps word in quotes, cs"' changes "..." → '...', ds" deletes
  {
    'kylechui/nvim-surround',
    version = '*',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  -- Auto-close & auto-rename JSX/TSX/HTML tags. Essential for React/Next/Nest.
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
}
