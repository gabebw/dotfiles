---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = function()
      --- Wrapper for setting up and enabling language-server
      ---@param ls string server name
      ---@param config? vim.lsp.Config
      local setup = function(ls, config)
        if config then
          vim.lsp.config(ls, config)
        end
        vim.lsp.enable(ls)
      end

      setup("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
            diagnostics = {
              enable = true,
            },
          },
        },
      })

      setup("ts_ls", {
        filetypes = {
          -- Do not initialize on JS files, because it tries to find the TS installation on random
          -- one-off JS files and then prints an error
          -- Copied from: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ts_ls.lua
          -- "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
        },
      })

      setup("ruby_lsp", {
        cmd = { "ruby-lsp" },
        init_options = {
          linters = { "standard" },
        },
      })

      setup("pylsp", {
        cmd = { "uvx", "--with", "python-lsp-ruff", "--from", "python-lsp-server[all]", "pylsp" },
        plugins = {
          ruff = {
            formatEnabled = true,
            enabled = true,
            extendSelect = { "ALL" },
            format = { "ALL" },
            executable = "uvx ruff",
          },
        },
      })

      setup("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              -- Tell the language server to recognize the `vim` global
              globals = {
                "vim",
              },
            },
          },
        },
      })

      setup("eslint", {
        settings = {
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectories = { mode = "auto" },
          format = true,
          validate = "on",
          packageManager = "yarn",
        },
      })

      setup("oxlint", {
        cmd = { "yarn", "oxlint", "--lsp" },
      })

      setup("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
}
