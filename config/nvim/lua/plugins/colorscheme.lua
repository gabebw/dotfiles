-- A search result that is not being actively typed (IncSearch) and does not have the cursor
-- on it (CurSearch)
vim.api.nvim_set_hl(0, "Search", { underline = true, bg = "NONE" })
-- Highlight for when typing a search
-- vim.api.nvim_set_hl(0, "IncSearch", { cterm = { bold = true }, fg = "#eeeeee", background = "#c074b2" })
-- Highlight for the search result being looked at
-- vim.api.nvim_set_hl(0, "CurSearch", { link = "Search" })

---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "zootedb0t/citruszest.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd [[ colorscheme citruszest ]]
    end,
  },
  {
    "oskarnurm/koda.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("koda").setup()
      vim.cmd [[ colorscheme koda-dark ]]
    end,
  },
}
