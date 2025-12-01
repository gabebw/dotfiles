---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "Saghen/blink.cmp",
    version = "1.*",
    ---@module "blink.cmp.config"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
        },
        completion = {
          list = {
            selection = {
              -- When `true`, will automatically select the first item in the completion list
              preselect = true,
              -- When `true`, inserts the completion item automatically when selecting it
              auto_insert = true,
            },
          },
        },
      },
      completion = {
        accept = { auto_brackets = { enabled = false } },
        menu = {
          auto_show = true,
          border = "single",
          draw = {
            columns = {
              { "kind_icon" },
              { "label" },
              { "source_id", gap = 1 },
            },
          },
        },
        -- Show documentation when selecting a completion item
        documentation = {
          auto_show = true,
          treesitter_highlighting = true,
          auto_show_delay_ms = 0,
        },
      },
      sources = {
        providers = {
          -- Defaults to `{ 'buffer' }`, which means "only show buffer if LSP has no results".
          -- When it's blank, we always show buffer completions.
          lsp = { fallbacks = {} },
        },
      },
    },
  },
}
