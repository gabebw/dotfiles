return {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Project Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble lsp_document_symbols toggle focus=true<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cf",
      function()
        require("trouble").open({
          mode = "lsp_document_symbols",
          focus = "true",
          -- Available kinds:
          -- "Class"
          -- "Constructor"
          -- "Enum"
          -- "Field"
          -- "Function"
          -- "Interface"
          -- "Method"
          -- "Module"
          -- "Namespace"
          -- "Package"
          -- "Property"
          -- "Struct"
          -- "Trait"
          filter = { kind = { "Function", "Constant" } },
          win = { position = "left" },
        })
      end,
      desc = "Function Symbols (Trouble)",
    },
  },
  modes = {
    preview_float = {
      mode = "diagnostics",
      preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        position = { 0, -2 },
        size = { width = 0.3, height = 0.3 },
        zindex = 200,
      },
    },
  },
}
