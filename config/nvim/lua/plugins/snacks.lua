local function fuzzy_find_specs()
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

local function fuzzy_find_files()
  Snacks.picker.files({
    hidden = true,
    layout = {
      cycle = true,
      preset = function()
        local wide_enough = vim.o.columns >= 120
        return wide_enough and "bottom" or "default"
      end,
    },
  })
end

local function CharacterUnderCursor()
  local column = vim.api.nvim_win_get_cursor(0)[2]
  return vim.api.nvim_get_current_line():sub(column, column + 1)
end

local GH_FILTERS = {}
GH_FILTERS.awaiting_my_feedback = "review-requested:@me"
GH_FILTERS.mine = "author:@me"

local function GH_PR(filter)
  Snacks.gh.pr({ state = "open", search = filter, live = false })
end

GH = {}
function GH.awaiting_my_feedback()
  GH_PR(GH_FILTERS.awaiting_my_feedback)
end

function GH.mine()
  GH_PR(GH_FILTERS.mine)
end

local function SearchableWordNearCursor()
  -- <cword> tries a little too hard to find a word.
  -- Given this (cursor at |):
  -- hello | there
  -- Then the <cword> is `there`.
  -- Thus, we use `CharacterUnderCursor` (which is precise) to determine if we're
  -- on a word at all.
  if CharacterUnderCursor():match "^%s$" then
    return ""
  else
    local word_under_cursor = vim.fn.expand "<cword>"
    -- Sometimes the word under the cursor includes punctuation, in which case
    -- '\bWORD!\b' will fail because \b is a word boundary and we have non-word
    -- characters in WORD. So, remove them. This results in a less-precise match
    -- (it'll find WORD as well as WORD!, for example), but is better than getting
    -- zero results.
    return word_under_cursor:gsub("[$!?]", "")
  end
end

local function SearchForWordUnderCursor()
  Snacks.picker.grep({
    search = SearchableWordNearCursor,
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
        fuzzy_find_files,
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
            glob = "*." .. current_file_extension,
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
      -- text objects: ai, ii
      scope = {},
      dashboard = {
        -- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
        preset = {
          ---@type snacks.dashboard.Item[]
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = fuzzy_find_files,
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "g",
              desc = "Grep",
              action = function()
                Snacks.dashboard.pick("live_grep", { hidden = true })
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
            {
              icon = " ",
              key = "b",
              desc = "Browse Repo",
              action = function()
                Snacks.gitbrowse()
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
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
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
      vim.keymap.set("n", "K", SearchForWordUnderCursor, { remap = false, desc = "Search for word under cursor" })
    end,
  },
}
