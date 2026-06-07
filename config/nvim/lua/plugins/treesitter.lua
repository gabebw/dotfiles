---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "css",
        "embedded_template", -- now it understands Erb
        "fish",
        "javascript",
        "markdown_inline",
        "ruby",
        "scala",
        "sql",
        "tsx",
        "typescript",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local parser = vim.treesitter.get_parser()

          if parser then
            -- Use treesitter language because it doesn't always match the filetype: for `*.erb`
            -- files, the filetype is "erb" but the treesitter language is "embedded_template"
            local treesitter_language = parser:lang()
            local parsers = require("nvim-treesitter").get_installed()
            if vim.tbl_contains(parsers, treesitter_language) then
              pcall(vim.treesitter.start, args.buf)
            end
          end
        end,
      })
    end,
  },
}
