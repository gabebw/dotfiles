return {
  "neovim/nvim-lspconfig",
  config = function()
    require("lspconfig").ruby_lsp.setup({
      cmd = { vim.fn.expand "~/.rbenv/shims/ruby-lsp" },
      init_options = {
        linters = { "standard" },
      },
    })
    require("lspconfig").pylsp.setup({
      cmd = { "uvx", "--from", "python-lsp-server[all]", "pylsp" },
      plugins = {
        ruff = {
          formatEnabled = true,
          executable = "uvx ruff",
        },
      },
    })
    require("lspconfig").lua_ls.setup({
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
  end,
}
