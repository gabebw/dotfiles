local function trailing_whitespace()
  local space = vim.fn.search([[\s\+$]], "nwc")
  return space ~= 0 and "TW:" .. space or ""
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "mini.nvim" },
    opts = {
      -- Themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
      options = {
        theme = "dracula",
      },

      -- Sections:
      -- +-------------------------------------------------+
      -- | A | B | C                             X | Y | Z |
      -- +-------------------------------------------------+
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          trailing_whitespace,
          "diagnostics",
          "lsp_status",
        },
        lualine_c = {
          {
            "filename",
            -- https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#filename-component-options
            -- `path` options:
            -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
            path = 1,
            symbols = {
              modified = "[+]",
              readonly = "[RO]",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "" },
        lualine_z = { "" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
    init = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
}
