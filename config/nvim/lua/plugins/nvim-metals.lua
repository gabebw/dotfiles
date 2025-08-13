return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "scala", "sbt", "java" },
  opts = function()
    local metals_config = require("metals").bare_config()

    -- Optimize memory allocation with serverProperties
    metals_config.settings = {
      serverProperties = {
        "-Xmx4G",
        "-Xms100m",
        "-XX:+UseG1GC",
        "-XX:MaxGCPauseMillis=200",
      },
      showImplicitArguments = true,
      excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl",
      },
      bloopSbtAlreadyInstalled = true, -- Set to true if you use Bloop
      enableSemanticHighlighting = false, -- Disable for better performance
      superMethodLensesEnabled = false, -- Disable additional lenses
      scalafixConfigPath = ".scalafix.conf", -- Only if you use Scalafix
    }

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        -- Show messages from Metals
        vim.opt_global.shortmess:remove "F"
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })

    -- Add custom commands for Metals
    vim.api.nvim_create_user_command("MetalsRestart", function()
      require("metals").restart_server()
    end, { nargs = 0 })

    vim.api.nvim_create_user_command("MetalsClean", function()
      vim.cmd "!bloop clean" -- Adjust if you use a different build tool
    end, { nargs = 0 })
  end,
}
