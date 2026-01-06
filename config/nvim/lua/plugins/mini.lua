---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-mini/mini.nvim",
    config = function()
      require("mini.icons").setup()
      require("mini.sessions").setup()

      -- https://nvim-mini.org/mini.nvim/doc/mini-comment.html
      require("mini.comment").setup()
    end,
    init = function()
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          vim.cmd [[ mksession! ]]
        end,
        pattern = "*",
      })
    end,
  },
}
