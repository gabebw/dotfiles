return {
  "debugloop/telescope-undo.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    -- don't use `defaults = { }` here, do this in the main telescope spec
    extensions = {
      undo = {
        side_by_side = true,
        layout_strategy = "horizontal",
        layout_config = {
          height = 0.8,
        },
        -- https://github.com/debugloop/telescope-undo.nvim?tab=readme-ov-file#configuration
        -- opts = {
        mappings = {
          -- Wrapping the actions inside a function prevents the error due to telescope-undo being not
          -- yet loaded.
          i = {
            ["<cr>"] = function(bufnr)
              require("telescope-undo.actions").restore(bufnr)
            end,
          },
        },
      },
    },
  },
  config = function(_, opts)
    -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
    -- configs for us.
    require("telescope").setup(opts)
    require("telescope").load_extension "undo"
  end,
}
