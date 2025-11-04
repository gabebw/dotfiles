local fuzzy_find_specs = function()
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
end

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
        preset = {
          ---@type snacks.dashboard.Item[]
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = function()
                Snacks.dashboard.pick("files", { hidden = true })
              end,
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = function()
                Snacks.dashboard.pick("live_grep", { hidden = true })
              end,
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = function()
                Snacks.picker.recent({
                  filter = {
                    paths = {
                      -- Hide this path
                      COMMIT_EDITMSG = false,
                    },
                  },
                })
              end,
            },
            {
              icon = "󰊪 ",
              key = "v",
              desc = "Plugin specs",
              action = fuzzy_find_specs,
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = function()
                Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath "config" })
              end,
            },
            {
              icon = " ",
              key = "s",
              desc = "Restore Session",
              section = "session",
              enabled = function()
                return require("mini.sessions").get_latest() ~= nil
              end,
            },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            cwd = true,
            --- @param path string
            filter = function(path)
              return path:match "COMMIT_EDITMSG" == nil
            end,
            limit = 15,
            indent = 2,
            padding = 1,
            pane = 2,
          },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1, pane = 2 },
          { section = "startup" },
        },
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
      vim.keymap.set("n", "<Leader>vv", fuzzy_find_specs, { remap = false, desc = "Fuzzy-find plugin specs" })
    end,
  },
}
