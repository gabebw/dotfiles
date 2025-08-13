-- Telescope is absolutely magic.
return {
  "nvim-telescope/telescope.nvim",
  -- branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "folke/trouble.nvim",
  },
  config = function()
    local open_with_trouble = require("trouble.sources.telescope").open
    -- Use this to add more results without clearing the trouble list
    -- local add_to_trouble = require("trouble.sources.telescope").add

    local actions = require "telescope.actions"
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-h>"] = actions.which_key,
            ["<CR>"] = actions.select_default,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<c-t>"] = open_with_trouble,
          },
          n = { ["<c-t>"] = open_with_trouble },
        },
      },
      extensions = {
        file_browser = {
          disable_devicons = true,
        },
      },
    })
    require("telescope").load_extension "fzf"
    require("telescope").load_extension "file_browser"
  end,
}
