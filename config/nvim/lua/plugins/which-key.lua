return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  --- @type wk.Opts
  opts = {
    -- https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
    preset = "modern",
    triggers = {
      { "<auto>", mode = "nxsoc" },
      { "q", mode = { "n" } },
    },
    ---@type wk.Win.opts
    win = {
      -- 0.5 = 50%
      -- 50 = 50 lines
      height = { min = 0.5, max = 0.8 },
      -- I don't care if it hides the cursor
      no_overlap = false,
    },
    -- expand groups if <=N mappings, e.g. show `g=` and `gc` instead of hiding under `g`
    expand = 5,
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
    {
      "<c-k>",
      mode = { "c" },
      function()
        require("which-key").show({})
      end,
      desc = "Command Mode Keymaps (which-key)",
    },
  },
}
