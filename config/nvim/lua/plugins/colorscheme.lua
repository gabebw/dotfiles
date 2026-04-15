local read_apple_interface_style = "defaults read -g AppleInterfaceStyle 2>/dev/null"

-- Function to set background based on macOS system theme
-- Copied from https://github.com/jsilasbailey/dotfiles/blob/9a09a365b84ad67b9a38c4b51004a2a4c7adcbf9/config/nvim/lua/plugins/colorscheme.lua
local function set_background_from_system()
  local handle = io.popen(read_apple_interface_style)

  if handle then
    local result = handle:read "*a"
    handle:close()

    if result:match "Dark" then
      vim.opt.background = "dark"
    else
      vim.opt.background = "light"
    end
  else
    vim.opt.background = "light"
  end
end

local function setup_auto_background_change()
  -- Set background on startup
  set_background_from_system()

  -- Update background when Neovim gains focus
  vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
    callback = function()
      set_background_from_system()
    end,
  })
end

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
    -- config = function()
    --   setup_auto_background_change()
    --   require("koda").setup()
    --   vim.cmd [[ colorscheme koda ]]
    -- end,
  },
  {
    "zenbones-theme/zenbones.nvim",
    lazy = false,
    priority = 1000,
    dependencies = "rktjmp/lush.nvim",
    config = function()
      setup_auto_background_change()
      vim.cmd [[ colorscheme zenwritten ]]

      -- A search result that is not being actively typed (IncSearch) and does not have the cursor
      -- on it (CurSearch)
      vim.api.nvim_set_hl(0, "Search", { underline = true, bg = "NONE" })
      -- Highlight for when typing a search
      -- vim.api.nvim_set_hl(0, "IncSearch", { cterm = { bold = true }, fg = "#eeeeee", background = "#c074b2" })
      -- Highlight for the search result being looked at
      -- vim.api.nvim_set_hl(0, "CurSearch", { link = "Search" })
    end,
  },
}
