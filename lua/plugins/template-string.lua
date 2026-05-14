-- template-string.nvim — auto-converts "..." or '...' to `...` when you type
-- `${` inside the string. Works in TS/JS/TSX/JSX/Vue/Svelte.
--
-- Example: type `const greeting = 'hi'`, then go back and change `'hi'` to
--   include an interpolation. As soon as you type `${`, the quotes become
--   backticks automatically.
return {
  'axelvc/template-string.nvim',
  event = 'InsertEnter',
  ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue', 'svelte', 'python' },
  opts = {
    filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue', 'svelte', 'python' },
    jsx_brackets = true,              -- in JSX, convert "foo" props to {`foo`} when needed
    remove_template_string = true,    -- inversely, ``no $`` → "..." when interpolation removed
    restore_quotes = { normal = [[']], jsx = [["]] },
  },
}
