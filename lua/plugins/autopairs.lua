-- nvim-autopairs — auto-inserts matching ), }, ], ", ', `, etc. and handles
-- smart deletion of pairs with backspace. Treesitter-aware so it doesn't
-- pair-up inside strings/comments where you don't want it.
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    check_ts = true,                  -- use treesitter to know if we're in a string/comment
    ts_config = {
      lua = { 'string' },
      javascript = { 'template_string' },
    },
    fast_wrap = {
      map = '<M-e>',                  -- Alt-e to wrap next text in pair
      chars = { '{', '[', '(', '"', "'" },
      pattern = [=[[%'%"%>%]%)%}%,]]=],
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'PmenuSel',
    },
  },
  config = function(_, opts)
    require('nvim-autopairs').setup(opts)
    -- Make autopairs and blink.cmp cooperate: pressing <CR> on a completion
    -- shouldn't both accept the completion AND insert a paired char.
    local cmp_ok, cmp = pcall(require, 'blink.cmp')
    if cmp_ok and cmp.add_pairs then
      -- blink.cmp has its own pair handling — autopairs alone is fine.
    end
  end,
}
