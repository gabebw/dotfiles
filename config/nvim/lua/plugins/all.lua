return {
  { "pangloss/vim-javascript" },
  { "MaxMEllon/vim-jsx-pretty" },
  {
    "HerringtonDarkholme/yats.vim",
    submodules = false,
    init = function()
      -- From the yats.vim README:
      -- > Note: set re=0 explicitly in your vimrc. Old regexp engine will incur performance issues for yats and old
      -- > engine is usually turned on by other plugins.
      vim.g.regexpengine = 0
    end,
  },

  -- Ruby/Rails
  {
    "tpope/vim-rails",
    init = function()
      vim.g.rails_projections = {
        ["config/routes.rb"] = { command = "routes" },
        ["app/admin/*.rb"] = {
          command = "admin",
          alternate = "spec/controllers/admin/{singular}_controller_spec.rb",
        },
        ["spec/controllers/admin/*_controller_spec.rb"] = {
          alternate = "app/admin/{plural}.rb",
        },
        ["app/components/*.html.erb"] = {
          alternate = "app/components/{}.rb",
        },
        ["app/components/*.rb"] = {
          alternate = "app/components/{}.html.erb",
        },
        ["spec/factories/*.rb"] = { command = "factories" },
        ["spec/factories.rb"] = { command = "factories" },
        ["spec/features/*_spec.rb"] = { command = "feature" },
        ["config/locales/en/*.yml"] = {
          command = "tran",
          template = "en:\n  {underscore|plural}:\n    ",
        },
        ["app/services/*.rb"] = {
          command = "service",
          test = "spec/services/{}_spec.rb",
        },
        ["script/datamigrate/*.rb"] = {
          command = "datamigrate",
          template = "#!/usr/bin/env rails runner\n\n",
        },
        ["app/jobs/*_job.rb"] = {
          command = "job",
          template = "class {camelcase|capitalize|colons}Job < ActiveJob::Job\n  def perform(*)\n  end\nend",
          test = { "spec/jobs/{}_job_spec.rb" },
        },
      }
    end,
  },
  { "vim-ruby/vim-ruby" },
  -- Allow `cir` to change inside ruby block, etc
  {
    "rhysd/vim-textobj-ruby",
    dependencies = { "kana/vim-textobj-user" },
    init = function()
      -- definitions blocks	(module, class, def): ro
      -- loop blocks (while, for, until): rl
      -- control blocks	(do, begin, if, unless, case): rc
      -- do statement	(do): rd
      -- any block (including above): rr
      vim.g.textobj_ruby_more_mappings = 1
    end,
  },
  { "tpope/vim-rake" },
  { "tpope/vim-projectionist" },
  {
    "janko-m/vim-test",
    init = function()
      vim.g["test#strategy"] = "vtr"
      vim.g["test#ruby#rspec#options"] = {
        nearest = "--format documentation",
        file = "--format documentation",
      }

      vim.cmd [[
          nnoremap <Leader>l :w<CR>:TestNearest<CR>:redraw!<CR>
          nnoremap <Leader>a :w<CR>:TestFile<CR>:redraw!<CR>
        ]]
    end,
  },
  { "airblade/vim-localorie" },

  { "dag/vim-fish" },

  -- tmux
  {
    "christoomey/vim-tmux-runner",

    init = function()
      -- Open runner pane to the right, not to the bottom
      vim.g.VtrOrientation = "h"
      -- Take up this percentage of the screen
      vim.g.VtrPercentage = 20
      vim.cmd [[
          " Attach to a specific pane
          nnoremap <leader>va :VtrAttachToPane<CR>
          nnoremap <leader>rr :w<CR>:VtrSendCommandToRunner eval (history search --prefix 'clear;' -n1)<CR>
        ]]
    end,
  },
  { "christoomey/vim-tmux-navigator" },

  -- Syntax
  { "rust-lang/rust.vim" },
  { "vim-scripts/applescript.vim" },
  { "shmup/vim-sql-syntax" },
  { "tpope/vim-git" },

  -- Plumbing that makes everything nicer
  -- Easily comment/uncomment lines in many languages
  { "tomtom/tcomment_vim" },

  -- <Tab> indents or triggers autocomplete, smartly
  {
    "ervandew/supertab",
    init = function()
      -- Tell Supertab to start completions at the top of the list, not the bottom.
      vim.g.SuperTabDefaultCompletionType = "<c-n>"
    end,
  },
  -- Git bindings
  { "tpope/vim-fugitive" },
  -- The Hub to vim-fugitive's git
  { "tpope/vim-rhubarb" },
  -- Auto-add `end` in Ruby, `endfunction` in Vim, etc
  { "tpope/vim-endwise" },
  -- When editing deeply/nested/file, auto-create deeply/nested/ dirs
  { "duggiefresh/vim-easydir" },
  -- Cool statusbar
  { "itchyny/lightline.vim" },
  -- Easily navigate directories
  { "tpope/vim-vinegar" },
  -- Make working with shell scripts nicer ("vim-unix")
  { "tpope/vim-eunuch" },
  { "tpope/vim-surround" },
  -- Make `.` work to repeat plugin actions too
  { "tpope/vim-repeat" },
  { "tpope/vim-unimpaired" },
  -- Intelligently reopen files where you left off
  { "farmergreg/vim-lastplace" },
  -- Instead of always copying to the system clipboard, use `cp` (plus motions) to
  -- copy to the system clipboard. `cP` copies the current line. `cv` pastes.
  { "christoomey/vim-system-copy" },
  -- `vim README.md:10` opens README.md at the 10th line, rather than saying "No
  -- such file: README.md:10"
  { "xim/file-line" },
  { "christoomey/vim-sort-motion" },
  {
    "zootedb0t/citruszest.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "xolox/vim-easytags",
    dependencies = { "xolox/vim-misc" },
    init = function()
      vim.g.easytags_events = {}
    end,
  },
  {
    "stevearc/conform.nvim",
    ---@type table | fun(plugin: LazyPlugin, table: table): conform.setupOpts
    ---@diagnostic disable-next-line: unused-local
    opts = function(plugin, table)
      -- `opts` is a function just so I can define the `prettier` variable. It could just as easily be a plain
      -- table.
      local prettier = { "prettierd", "prettier", stop_after_first = true }

      -- If prettier fails, try switching Yarn from `pnp` to `node-modules` linker, or add this config: https://github.com/stevearc/conform.nvim/issues/323#issuecomment-2053692761

      -- This will provide type hinting with LuaLS
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
  },

  -- Text objects
  -- `ae` text object, so `gcae` comments whole file
  { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },
  -- `l` text object for the current line excluding leading whitespace
  { "kana/vim-textobj-line", dependencies = { "kana/vim-textobj-user" } },

  -- Markdown
  { "nicholaides/words-to-avoid.vim", ft = "markdown" },
  -- Make `gx` work on 'gabebw/dotfiles' too
  {
    "chrishrb/gx.nvim",
    submodules = false,
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    opts = {
      -- These handlers have higher precedence than builtin handlers
      handlers = {
        -- custom handler to open Linear tickets
        linear = {
          name = "linear",
          handle = function(mode, line, _)
            -- %u == \u in vim's patterns, i.e. uppercase
            local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
            if ticket and #ticket < 20 then
              return "https://linear.app/august-health/issue/" .. ticket
            end
          end,
        },
      },
    },
  },
  { "wesleimp/stylua.nvim" },

  -- LSP stuff
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

      vim.lsp.enable "ts_ls"

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
    end,
  },

  {
    "Saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "super-tab" },
      completion = {
        accept = { auto_brackets = { enabled = false } },
        menu = {
          auto_show = true,
          border = "single",
          draw = {
            columns = {
              { "kind_icon" },
              { "label" },
              { "source_id", gap = 1 },
            },
          },
        },
        -- Show documentation when selecting a completion item
        documentation = {
          auto_show = true,
          treesitter_highlighting = true,
          auto_show_delay_ms = 0,
        },
      },
      sources = {
        providers = {
          -- Defaults to `{ 'buffer' }`, which means "only show buffer if LSP has no results".
          -- When it's blank, we always show buffer completions.
          lsp = { fallbacks = {} },
        },
      },
    },
  },

  { "folke/lazydev.nvim", opts = {} },

  -- Telescope is absolutely magic.
  {
    "nvim-telescope/telescope.nvim",
    -- branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local actions = require "telescope.actions"
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = actions.which_key,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
            },
          },
        },
      })
      require("telescope").load_extension "fzf"
    end,
  },
  -- Use (ported version of) FZF for better performance and to support FZF syntax
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = "horizontal",
          layout_config = {
            height = 0.8,
          },
          -- https://github.com/debugloop/telescope-undo.nvim?tab=readme-ov-file#configuration
          -- opts = {
          mappings = {
            -- Wrapping the actions inside a function prevents the error due to telescope-undo being not
            -- yet loaded.
            i = {
              ["<cr>"] = function(bufnr)
                require("telescope-undo.actions").restore(bufnr)
              end,
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us.
      require("telescope").setup(opts)
      require("telescope").setup({
        pickers = {
          find_files = { hidden = true },
        },
      })
      require("telescope").load_extension "undo"
    end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("neoclip").setup()
      vim.cmd [[
          autocmd BufEnter * nmap <buffer> " :Telescope neoclip<CR>
          autocmd BufEnter * imap <buffer> <c-x> <Esc>:Telescope neoclip<CR>
        ]]
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false, -- Turn into false from true by default
      },
      actions = {
        change_dir = {
          enable = false,
        },
      },
      filters = {
        -- Show gitignored files (defaults to true, meaning DON'T show them.)
        -- This is an annoying default, because it means that sometimes newly created files will just not show up in
        -- the tree.
        git_ignored = false,
      },
      renderer = {
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
            modified = false,
            hidden = false,
            diagnostics = false,
            bookmarks = false,
          },
        },
      },
    },
    init = function()
      -- optionally enable 24-bit colour
      vim.opt.termguicolors = true
    end,
  },
  {
    {
      "scalameta/nvim-metals",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "j-hui/fidget.nvim",
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
    {
      "j-hui/fidget.nvim",
      opts = {},
    },
    {
      "folke/snacks.nvim",
      ---@type snacks.Config
      opts = {
        -- Fancy notifications!
        -- fidget.nvim can show notifications with
        --   opts = {
        --     notification = {
        --       override_vim_notify = true,
        --     },
        --   },
        -- but I like this more. I want notifications to be a little less obtrusive, while fidget is great for LSP
        -- progress notifications.
        notifier = {},
      },
    },
    {
      "folke/trouble.nvim",
      opts = {
        modes = {
          top_level_only = {
            mode = "lsp_document_symbols",
            filter = function(items)
              return vim.tbl_filter(function(item)
                return not item.parent
                -- allow 2nd-level:
                -- or not item.parent.parent
              end, items)
            end,
          },
          preview_float = {
            mode = "diagnostics",
            preview = {
              type = "float",
              relative = "editor",
              border = "rounded",
              title = "Preview",
              title_pos = "center",
              position = { 0, -2 },
              size = { width = 0.3, height = 0.3 },
              zindex = 200,
            },
          },
        },
      }, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble preview_float toggle filter.buf=0 focus=true<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Project Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble lsp_document_symbols toggle focus=true<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cf",
          function()
            local t = require "trouble"
            ---@diagnostic disable-next-line: missing-fields
            t.toggle({
              mode = "lsp_document_symbols",
              focus = "true",
              -- Available kinds:
              -- "Class"
              -- "Constructor"
              -- "Enum"
              -- "Field"
              -- "Function"
              -- "Interface"
              -- "Method"
              -- "Module"
              -- "Namespace"
              -- "Package"
              -- "Property"
              -- "Struct"
              -- "Trait"
              filter = { kind = { "Function", "Constant" } },
              -- If `size` is < 1, it is treated as a percentage (0.4 = 40%).
              -- Otherwise, it's treated as absolute number of columns.
              win = { position = "left", size = 0.25 },
            })
            if t.is_open "lsp_document_symbols" then
              -- Key bindings: zm to fold [m]ore (show less), zr to fold [r]educe (show more)

              -- Set fold level to 2, by setting to:
              -- 0 ("Document Symbols")
              ---@diagnostic disable-next-line: missing-parameter
              t.fold_close_all()

              -- 3 times:
              -- + 1 (filename)
              -- + 1 (top level)
              -- + 1 (nested level below that)
              for _ = 1, 3 do
                ---@diagnostic disable-next-line: missing-parameter
                t.fold_reduce()
              end
            end
          end,
          desc = "Function Symbols (Trouble)",
        },
      },
    },
  },
}
