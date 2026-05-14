-- ts-context-commentstring — fixes commenting in JSX/TSX/Vue/Svelte/Astro.
--
-- Problem: Neovim's built-in `gcc` uses one comment style per filetype.
-- In a .tsx file the default is `//`, but `// <div>` is invalid inside JSX
-- (must be `{/* <div> */}`).
--
-- This plugin watches the cursor's treesitter context and switches the comment
-- string accordingly: `//` inside the JS body, `{/* */}` inside JSX expressions.
-- Required for any serious React/Vue/Svelte/Astro work.
return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    enable_autocmd = false,           -- modern integration uses get_option override below
  },
  init = function()
    -- Wire ts-context-commentstring into nvim's built-in `commentstring` lookup.
    -- This makes `gcc` (and visual gc) correct in JSX/TSX/Vue/Svelte/Astro.
    local get_option = vim.filetype.get_option
    vim.filetype.get_option = function(filetype, option)
      return option == 'commentstring'
          and require('ts_context_commentstring.internal').calculate_commentstring()
          or get_option(filetype, option)
    end
  end,
}
