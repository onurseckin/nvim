-- Icon set used by snacks, lualine, and others.
-- mini.icons is lighter than nvim-web-devicons and integrates better with snacks.
return {
  'echasnovski/mini.icons',
  lazy = true,
  opts = {},
  init = function()
    -- Provide a shim so plugins requesting 'nvim-web-devicons' get mini.icons under the hood.
    package.preload['nvim-web-devicons'] = function()
      require('mini.icons').mock_nvim_web_devicons()
      return package.loaded['nvim-web-devicons']
    end
  end,
}
