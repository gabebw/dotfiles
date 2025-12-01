---@module "lazy.types"
---@type LazySpec[]
return {
  -- Telescope is absolutely magic.
  {
    "nvim-telescope/telescope.nvim",
    -- branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local actions = require "telescope.actions"
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = actions.which_key,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
            },
          },
        },
      })
      require("telescope").load_extension "fzf"
    end,
  },
  -- Use (ported version of) FZF for better performance and to support FZF syntax
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}
