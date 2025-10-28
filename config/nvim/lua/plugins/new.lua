return {
  {
    "ggandor/leap.nvim",
    init = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
    end,
  },
  { "lewis6991/gitsigns.nvim" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    --- @type wk.Opts
    opts = {
      -- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
      preset = "modern",
      triggers = {
        { "<auto>", mode = "nxso" },
        { "q", mode = { "n" } },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
