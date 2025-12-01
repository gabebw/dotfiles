---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "chrishrb/gx.nvim",
    submodules = false,
    keys = {
      {
        "gx",
        function()
          require("gx").open()
        end,
        mode = { "n", "x" },
        desc = "Open URL with gx",
      },
    },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    ---@module "gx"
    ---@type GxOptions
    opts = {
      -- If multiple URLs match, use the top one without prompting
      select_prompt = false,
      -- These handlers have higher precedence than builtin handlers
      handlers = {
        -- custom handler to open Linear tickets
        linear = {
          name = "linear",
          handle = function(mode, line, _)
            -- %u == \u in vim's patterns, i.e. uppercase
            local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
            if ticket and #ticket < 20 then
              return "https://linear.app/august-health/issue/" .. ticket
            end
          end,
        },
      },
    },
  },
}
