return {
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*",
    dependencies = {
      -- 'friendly-snippets' contains a variety of premade snippets.
      -- See the README about individual language/framework/plugin snippets: https://github.com/rafamadriz/friendly-snippets
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    -- install jsregexp (optional!).
    -- To apply Variable/Placeholder-transformations, LuaSnip needs to apply ECMAScript regular expressions. This is implemented by relying on jsregexp.
    -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#transformations
    build = "make install_jsregexp",
    init = function()
      local ls = require "luasnip"

      vim.keymap.set({ "i" }, "<C-K>", function()
        ls.expand()
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-L>", function()
        ls.jump(1)
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-J>", function()
        ls.jump(-1)
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-E>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end,
  },
}
