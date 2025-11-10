local function trailing_whitespace()
  local space = vim.fn.search([[\s\+$]], "nwc")
  return space ~= 0 and "TW:" .. space or ""
end

--- @param trunc_len number truncates component to trunc_len number of chars
--- return function that can format the component accordingly
local function trunc(trunc_len)
  return function(str)
    if trunc_len and #str > trunc_len then
      return str:sub(1, trunc_len) .. "..."
    end
    return str
  end
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
          { "branch", fmt = trunc(30) },
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
            -- Shortens path to leave 40 spaces in the window
            shorting_target = 100,
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
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = {
          {
            "tabs",

            -- can also be a function
            max_length = vim.o.columns,

            -- 0: Shows tab_nr
            -- 1: Shows tab_name
            -- 2: Shows tab_nr + tab_name
            mode = 2,

            -- 0: just shows the filename
            -- 1: shows the relative path and shorten $HOME to ~
            -- 2: shows the full path
            -- 3: shows the full path and shorten $HOME to ~
            path = 0,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
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
