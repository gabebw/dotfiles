---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "folke/trouble.nvim",
    ---@module "trouble"
    ---@type trouble.Config
    opts = {
      modes = {
        top_level_only = {
          mode = "lsp_document_symbols",
          filter = function(items)
            return vim.tbl_filter(function(item)
              return not item.parent
              -- allow 2nd-level:
              -- or not item.parent.parent
            end, items)
          end,
        },
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
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble preview_float toggle filter.buf=0 focus=true<cr>",
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
          local t = require "trouble"
          ---@diagnostic disable-next-line: missing-fields
          t.toggle({
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
            -- If `size` is < 1, it is treated as a percentage (0.4 = 40%).
            -- Otherwise, it's treated as absolute number of columns.
            win = { position = "left", size = 0.25 },
          })
          if t.is_open "lsp_document_symbols" then
            -- Key bindings: zm to fold [m]ore (show less), zr to fold [r]educe (show more)

            -- Set fold level to 2, by setting to:
            -- 0 ("Document Symbols")
            ---@diagnostic disable-next-line: missing-parameter
            t.fold_close_all()

            -- 3 times:
            -- + 1 (filename)
            -- + 1 (top level)
            -- + 1 (nested level below that)
            for _ = 1, 3 do
              ---@diagnostic disable-next-line: missing-parameter
              t.fold_reduce()
            end
          end
        end,
        desc = "Function Symbols (Trouble)",
      },
    },
  },
}
