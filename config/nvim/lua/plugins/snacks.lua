return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      -- https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      {
        "<Leader>t",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = "File picker",
      },
      {
        "<Leader>b",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffer picker",
      },
      {
        -- Really it's replacing `q:`, but `q;` is easier to type
        "q;",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Fuzzy command history",
      },
      {
        "q/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Fuzzy search history",
      },
      {
        "<Leader>j",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Fuzzy jump list",
      },
      {
        "<Leader>gg",
        function()
          Snacks.picker.grep({ hidden = true })
        end,
        desc = "Live grep",
      },
      {
        "<Leader>gG",
        function()
          local current_file_extension = vim.fn.expand "%:e"
          Snacks.picker.grep({
            hidden = true,
            args = { "--glob", "*." .. current_file_extension },
          })
        end,
        desc = "Live grep, filtered to this file's extension",
      },
      {
        "<Leader>go",
        function()
          Snacks.picker.grep_buffers({
            regex = false,
          })
        end,
        desc = "Grep open buffers (literal search)",
      },
      {
        "<Leader>n",
        function()
          -- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
          Snacks.picker.explorer({ cwd = vim.fn.expand "%:p:h" })
        end,
        desc = "Toggle file explorer",
      },
      {
        "<Leader>u",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo history",
      },
      {
        "<Leader>pp",
        function()
          Snacks.picker.pickers()
        end,
        desc = "Show a meta-picker",
      },
    },
    ---@module "snacks"
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
      -- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
      lazygit = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/scope.md
      scope = {},
      statuscolumn = {},
      -- https://github.com/folke/snacks.nvim/blob/main/docs/words.md
      words = {},
      dashboard = {
        -- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
      },
      picker = {
        win = {
          input = {
            keys = {
              ["<a-r>"] = { "toggle_regex", mode = { "i", "n" } },
            },
          },
        },
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["Y"] = { "copy_path_to_clipboard", mode = { "n", "x" } },
                },
              },
            },
            actions = {
              copy_path_to_clipboard = function()
                vim.cmd [[ normal "+y ]]
              end,
            },
          },
        },
      },
    },
    init = function()
      vim.keymap.set("n", "<Leader>vv", function()
        Snacks.picker.lazy({
          matcher = { sort_empty = true },
          sort = function(a, b)
            -- Sort by modification time, most recent at the top
            return vim.fn.getftime(a.file) > vim.fn.getftime(b.file)
          end,
          win = {
            input = {
              keys = {
                -- Open in tab by default
                ["<CR>"] = { "tab", mode = { "n", "i" } },
              },
            },
          },
        })
      end, { remap = false, desc = "Fuzzy-find plugin specs" })
    end,
  },
}
