---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ---@module "todo-comments"
    ---@type TodoOptions
    opts = {},
  },
}
