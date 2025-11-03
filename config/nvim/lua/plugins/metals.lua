return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "j-hui/fidget.nvim",
      -- Telescope is just for the Metals commands picker
      "nvim-telescope/telescope.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()

      -- https://github.com/scalameta/nvim-metals/discussions/39
      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to either "off" or "on"
      --
      -- "off" will enable LSP progress notifications by Metals and you'll need
      -- to ensure you have a plugin like fidget.nvim installed to handle them.
      --
      -- "on" will enable the custom Metals status extension and you *have* to have
      -- a have settings to capture this in your statusline or else you'll not see
      -- any messages from metals. There is more info in the help docs about this
      metals_config.init_options.statusBarProvider = "off"

      -- Optimize memory allocation with serverProperties
      metals_config.settings = {
        serverProperties = {
          -- Initial (minimum) heap size
          "-Xms10m",
          -- Max heap size (default 1/4 physical memory)
          "-Xmx2G",
          "-XX:+UseG1GC",
          "-XX:+UseStringDeduplication",
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

          -- Metals provides a custom picker from
          -- https://github.com/nvim-telescope/telescope.nvim which allows you to easily
          -- choose any of the |metals-commands|. You can trigger the picker by using the
          -- following function in a mapping: >
          --
          --   lua require("telescope").extensions.metals.commands()
          --
          -- If this is the only way you'll trigger the picker, then there is no need to
          -- explicitly load it in your telescope config. However, if you want the module
          -- to be autocompleted when trying to trigger it via: >
          --
          --   :Telescope metals commands
          vim.keymap.set("n", "<Leader>mm", require("telescope").extensions.metals.commands, { buffer = true })
        end,
        group = nvim_metals_group,
      })

      -- Add custom commands for Metals
      vim.api.nvim_create_user_command("MetalsRestart", function()
        require("metals").restart_metals()
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("MetalsClean", function()
        require("metals").compile_clean()
      end, { nargs = 0 })
    end,
  },
}
