---@module "lazy.types"
---@type LazySpec[]
return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "esmuellert/codediff.nvim", -- optional

    -- For a custom log pager (optional)
    "m00qek/baleia.nvim",
  },
  cmd = "Neogit",
  keys = {
    { "<leader>ng", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
}
