-- DAP = Debug Adapter Protocol
return {
  {
    -- Debugging in Rails:
    -- 1) bundle add debug
    -- 2) RUBY_DEBUG_OPEN=true RUBY_DEBUG_HOST=127.0.0.1 RUBY_DEBUG_PORT=38698 bin/dev
    -- 3) :DapContinue
    "suketa/nvim-dap-ruby",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("dap-ruby").setup()
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {},
  },
}
