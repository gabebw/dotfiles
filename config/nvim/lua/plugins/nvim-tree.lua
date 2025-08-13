return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    live_filter = {
      prefix = "[FILTER]: ",
      always_show_folders = false, -- Turn into false from true by default
    },
    actions = {
      change_dir = {
        enable = false,
      },
    },
    renderer = {
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = false,
          modified = false,
          hidden = false,
          diagnostics = false,
          bookmarks = false,
        },
      },
    },
  },
  init = function()
    -- optionally enable 24-bit colour
    vim.opt.termguicolors = true
  end,
}
