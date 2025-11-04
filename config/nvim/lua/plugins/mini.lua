return {
  {
    "nvim-mini/mini.nvim",
    config = function()
      require("mini.icons").setup()
      require("mini.sessions").setup()

      -- https://nvim-mini.org/mini.nvim/doc/mini-comment.html
      require("mini.comment").setup()
    end,
  },
}
