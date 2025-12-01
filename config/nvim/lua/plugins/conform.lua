---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "stevearc/conform.nvim",
    opts = function()
      -- `opts` is a function just so I can define the `prettier` variable. It could just as easily be a plain
      -- table.
      local prettier = { "prettierd", "prettier", stop_after_first = true }

      -- If prettier fails, try switching Yarn from `pnp` to `node-modules` linker, or add this config: https://github.com/stevearc/conform.nvim/issues/323#issuecomment-2053692761

      ---@module "conform"
      ---@type conform.setupOpts
      return {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff" },
          javascript = prettier,
          typescriptreact = prettier,
          typescript = prettier,
          css = prettier,
          ["eruby.yaml"] = prettier,
          ruby = { "standardrb" },
          eruby = { "erb_lint" },
          markdown = prettier,
          json = prettier,
          jsonc = prettier,
          sql = {
            -- This has its own `condition`, so run it on every SQL file
            "sql_formatter_play",
          },
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
          sql_formatter_play = {
            command = "sql-formatter-play-evolutions",
            exit_codes = { 0 },
            condition = function(_, ctx)
              return ctx.filename:match "conf/%d+.sql$"
            end,
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
      }
    end,
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
    init = function()
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },
}
