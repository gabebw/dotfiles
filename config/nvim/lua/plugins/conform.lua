return {
  "stevearc/conform.nvim",
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      ["eruby.yaml"] = { "prettierd", "prettier", stop_after_first = true },
      ruby = { "standardrb" },
      eruby = { "erb_lint" },
      markdown = { "prettierd", "prettier", stop_after_first = true },
    },
    formatters = {
      erb_lint = {
        stdin = false,
        tmpfile_format = ".conform.$RANDOM.$FILENAME",
        command = "bundle",
        args = { "exec", "erb_lint", "--autocorrect", "$FILENAME" },
      },
      ruff = {
        command = "uvx",
        args = {
          "ruff",
          "format",
          "--force-exclude",
          "--stdin-filename",
          "$FILENAME",
          "-",
        },
      },
    },
    -- If this is set, Conform will run the formatter asynchronously after save.
    -- It will pass the table to conform.format().
    format_after_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  },
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fo",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format buffer",
    },
  },
}
