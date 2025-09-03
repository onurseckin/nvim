# Agent Guidelines for AstroNvim Configuration

## Build/Lint/Test Commands
- **Format code**: `stylua .` (uses .stylua.toml config)
- **Lint code**: `selene .` (uses selene.toml config)
- **Type check**: Lua LSP handles type checking via .luarc.json
- **No tests**: This is a Neovim config, no test framework needed

## Code Style Guidelines

### Formatting
- Use 2-space indentation
- Max line width: 120 characters
- Unix line endings
- Auto-prefer double quotes
- No parentheses around function calls when unambiguous

### Lua Patterns
- Use EmmyLua annotations: `---@type LazySpec`, `---@param`, etc.
- Table concatenation with `table.concat()` for multiline strings
- Plugin specs use LazySpec format with opts/config functions
- Use `require()` for module imports

### Naming Conventions
- Functions: camelCase (e.g., `setupConfig()`)
- Variables: snake_case (e.g., `local config_opts`)
- Files: snake_case (e.g., `lazy_setup.lua`)
- Plugin files: lowercase (e.g., `astroui.lua`)

### Error Handling
- Use `pcall()` for safe require calls
- Check `vim.v.shell_error` for system command results
- Use `vim.api.nvim_echo()` for user notifications

### Imports & Dependencies
- Use Lazy.nvim for plugin management
- Import plugins via `require("lazy").setup()`
- Use `import = "plugins"` for plugin organization
- Follow AstroNvim plugin structure

### Best Practices
- Add `-- stylua: ignore` comments for intentional formatting deviations
- Use `---@diagnostic disable` for intentional linter suppressions
- Keep plugin configurations modular in separate files
- Use `opts = {}` for simple configurations, `config = function()` for complex ones