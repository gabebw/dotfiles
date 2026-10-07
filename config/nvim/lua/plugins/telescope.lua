---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-telescope/telescope.nvim",
    -- branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
    ft = { "scala" },
    opts = {},
  },
}
