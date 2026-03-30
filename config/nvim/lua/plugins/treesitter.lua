---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    ---@module "nvim-treesitter.config"
    ---@type TSConfig
    opts = {},
    setup = function()
      require("nvim-treesitter").install({
        "css",
        "embedded_template", -- now it understands Erb
        "fish",
        "javascript",
        "markdown_inline",
        "ruby",
        "scala",
        "sql",
        "tsx",
        "typescript",
      })
    end,
  },
}
