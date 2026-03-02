---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
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
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
      })

      setup("ruby_lsp", {
        cmd = { "ruby-lsp" },
        init_options = {
          linters = { "standard" },
        },
      })

      setup("pylsp", {
        cmd = { "uvx", "--from", "python-lsp-server[all]", "pylsp" },
        plugins = {
          ruff = {
            formatEnabled = true,
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

      setup "herb_ls"

      setup("oxlint", {
        cmd = { "yarn", "oxlint", "--lsp" },
      })
    end,
  },
}
