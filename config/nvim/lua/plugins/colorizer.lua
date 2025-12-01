---@module "lazy.types"
---@type LazySpec[]
return {
  {
    -- Show hex codes in their color
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = function()
      local with_tailwind = {
        tailwind = true,
        tailwind_opts = {
          -- When using tailwind = 'both', update tailwind names from LSP results.
          update_names = "both",
        },
      }
      return {
        filetypes = {
          "cmp_menu",
          "cmp_docs",
          "fish",
          typescriptreact = with_tailwind,
          typescript = with_tailwind,
          css = {
            -- Enable all CSS features (hsla(), rgb(), etc)
            css = true,
          },
          toml = {
            RGB = true,
            names_opts = { -- options for mutating/filtering names.
              lowercase = true,
              css = true,
            },
            mode = "inline",
            -- Turn off names because it highlights the aqua in `color_aqua`, instead of respecting word boundaries.
            names = false,
          },
        },
      }
    end,
  },
}
