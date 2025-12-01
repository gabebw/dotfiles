---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "lewis6991/gitsigns.nvim",
    ---@module "gitsigns"
    opts = {
      -- On hover, show blame for current line
      current_line_blame = true,

      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]h", bang = true })
          else
            require("gitsigns.actions.nav").nav_hunk "next"
          end
        end, { desc = "Next Git hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[h", bang = true })
          else
            require("gitsigns.actions.nav").nav_hunk "prev"
          end
        end, { desc = "Previous Git hunk" })

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Git hunk" })
      end,
    },
  },
}
