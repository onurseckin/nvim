-- nvim-colorizer.lua — inline color swatches for hex codes, rgb/hsl, Tailwind
-- class names. Essential for any Tailwind / CSS work.
return {
  'catgoose/nvim-colorizer.lua',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    user_default_options = {
      RGB = true,
      RRGGBB = true,
      RRGGBBAA = true,
      rgb_fn = true,
      hsl_fn = true,
      css = true,
      css_fn = true,
      tailwind = 'both',
      mode = 'background',
      virtualtext = '■',
    },
    filetypes = {
      'css', 'scss', 'sass', 'html',
      'javascript', 'javascriptreact',
      'typescript', 'typescriptreact', 'vue', 'svelte',
      'lua', 'json', 'yaml', 'toml',
      'markdown',
    },
  },
}
