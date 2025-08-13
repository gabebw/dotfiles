return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- nvim-cmp source for words in the buffer
    "hrsh7th/cmp-buffer",
    -- Autocomplete filesystem paths as you type them. Neat!
    "hrsh7th/cmp-path",
  },
  config = function()
    local cmp = require "cmp"

    -- `has_words_before` and the functions that use it are copied from
    -- the nvim-cmp README.
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end
    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = function(fallback)
          if not cmp.select_next_item() then
            if vim.bo.buftype ~= "prompt" and has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end
        end,

        ["<S-Tab>"] = function(fallback)
          if not cmp.select_prev_item() then
            if vim.bo.buftype ~= "prompt" and has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end
        end,
      }),
      sources = cmp.config.sources({ { name = "nvim_lsp" } }, {
        { name = "path" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              -- return vim.api.nvim_list_bufs()
              -- Complete from open buffers
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
      }),
      sorting = {
        priority_weight = 1,
        comparators = {
          function(...)
            -- Prefer words that are closer
            return require("cmp_buffer"):compare_locality(...)
          end,
        },
      },
    })
  end,
}
