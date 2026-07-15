local function path_exists(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "file" or false
end

---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local lume = require "lume"

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

      lume.each({ "ts_ls" }, function(name)
        setup(name, {
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
      end)

      setup("tsgo", {
        cmd = function(dispatchers, config)
          -- override the command to not be `tsgo`:
          -- https://github.com/neovim/nvim-lspconfig/blob/d224a1920728ba129880efc700d4a0180ac4ecbb/lsp/tsgo.lua#L65
          local cmd = "tsc"

          if (config or {}).root_dir then
            local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
            if vim.fn.executable(local_cmd) == 1 then
              cmd = local_cmd
            end
          end
          return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
        end,
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

      local oxlint_default_root_dir = vim.lsp.config["oxlint"].root_dir
      --- @param root_dir string?
      local oxlint_executable_in = function(root_dir)
        if root_dir then
          return root_dir .. "/node_modules/.bin/oxlint"
        else
          return nil
        end
      end

      setup("oxlint", {
        cmd = function(dispatchers, config)
          return vim.lsp.rpc.start({ oxlint_executable_in(config.root_dir), "--lsp" }, dispatchers)
        end,
        -- Only start when oxlint is actually runnable.
        -- If we never call `on_dir`, then the server doesn't start.
        root_dir = function(bufnr, on_dir)
          if oxlint_default_root_dir then
            oxlint_default_root_dir(bufnr, function(dir)
              if dir then
                local project_node_modules = vim.fs.root(dir, "node_modules")
                local executable_path = oxlint_executable_in(project_node_modules)
                if vim.fn.executable "oxlint" == 1 or (executable_path and vim.fn.executable(executable_path)) then
                  on_dir(dir)
                end
              end
            end)
          end
        end,
      })

      local json = require("schemastore").json
      local extend_file_match = function(name, new_patterns)
        if not json.get(name) then
          vim.notify('Oops, no schema for "' .. name .. '"', vim.log.levels.ERROR)
          return ""
        end
        return lume.extend(json.get(name), {
          fileMatch = lume.extend(json.get(name).fileMatch, new_patterns),
        })
      end

      setup("jsonls", {
        settings = {
          json = {
            schemas = json.schemas({
              replace = {
                oxfmt = extend_file_match("oxfmt", {
                  -- When editing the un-dotted file in dotfiles, turn on the LSP
                  "dotfiles/oxfmtrc.json",
                }),
                oxlint = extend_file_match("oxlint", {
                  -- When editing the un-dotted file in dotfiles, turn on the LSP
                  "dotfiles/oxlintrc.json",
                }),
                ["prettierrc.json"] = extend_file_match("prettierrc.json", {
                  -- When editing the un-dotted file in dotfiles, turn on the LSP
                  "dotfiles/prettierrc.json",
                }),
              },
            }),
            validate = { enable = true },
          },
        },
      })

      -- https://github.com/neovim/nvim-lspconfig/blob/451d4ef9abd4f0f08e379ef0d55d1c391b6125a7/lsp/tailwindcss.lua#L102
      local defaultTailwindClassAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      }
      setup("tailwindcss", {
        settings = {
          tailwindCSS = {
            -- Can use regexes in `classAttributes` and `classFunctions`
            -- Defaults: https://github.com/tailwindlabs/tailwindcss-intellisense/blob/3c7bd0c009b8260386e05fa3574e936d987bbd78/packages/tailwindcss-language-service/src/util/state.ts#L46
            classAttributes = lume.extend(defaultTailwindClassAttributes, { ".+ClassName", "triggerStyle" }),
            classFunctions = { "tw", "clsx", "tw\\.[a-z-]+" },
          },
        },
      })

      setup "bashls"

      setup("yamlls", {
        settings = {
          yaml = {
            schemas = json.schemas(),
          },
        },
      })
    end,
  },
}
