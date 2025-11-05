return {
  {
    "nvim-mini/mini.nvim",
    config = function()
      require("mini.icons").setup()
      require("mini.sessions").setup()

      -- https://nvim-mini.org/mini.nvim/doc/mini-bracketed.html
      require("mini.bracketed").setup()

      -- https://nvim-mini.org/mini.nvim/doc/mini-surround.html
      require("mini.surround").setup()

      -- https://nvim-mini.org/mini.nvim/doc/mini-comment.html
      require("mini.comment").setup()

      -- Copy/paste with system clipboard
      vim.keymap.set({ "n", "x" }, "cp", '"+y', { remap = false, desc = "Copy to system clipboard" })
      vim.keymap.set("n", "cv", ":pu +<CR>==", { remap = false, desc = "Paste from system clipboard below this line" })
      -- Paste in Visual with `P` to not copy selected text (`:h v_P`)
      vim.keymap.set("x", "cv", '"+P', { remap = false, desc = "Paste from system clipboard" })

      -- https://nvim-mini.org/mini.nvim/doc/mini-ai.html
      local gen_ai_spec = require("mini.extra").gen_ai_spec
      require("mini.ai").setup({
        mappings = {
          around_last = "aL",
          inside_last = "iL",
        },
        custom_textobjects = {
          F = gen_ai_spec.buffer(),
          l = gen_ai_spec.line(),
          N = gen_ai_spec.number(),
        },
      })
    end,
  },
}
