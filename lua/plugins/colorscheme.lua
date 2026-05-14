-- Colorscheme: tokyonight (folke's). Several variants — we use "night" (darkest).
-- Swap variant by changing `style` below. Loaded with priority=1000 so it
-- applies before any other plugin.
return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    style = 'night',          -- night | storm | moon | day
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
    },
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight'
  end,
}
