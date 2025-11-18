return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  keys = {
    -- Since these are mostly regular keys as well as operator-pending ("o"),
    -- you can just type the key (e.g. "S") or you can type an operator (`:help operator`), like
    -- `yS`, to kick it off.
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      -- Incrementally search up the tree (with expanding chunks).
      -- Use ; and , to make it bigger/smaller.
      "S",
      mode = { "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter Range",
    },
    {
      -- Incrementally search up the tree (with expanding chunks).
      -- Use ; and , to make it bigger/smaller.
      "S",
      mode = { "n" },
      function()
        require("flash").treesitter({ jump = { pos = "start" } })
      end,
      desc = "Flash Treesitter",
    },
    {
      -- Operate remotely: do a thing far away from your cursor, then jump back.
      -- e.g. `dr` to kick off deletion in remote mode, then type a search string, press `d` to
      -- delete the line
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      -- Search for a string, then you can select treesitter ranges that contain it
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        local enabled = require("flash").toggle()
        local description
        local prefix = ""
        if enabled then
          description = "**enabled**"
          prefix = "󱐋 "
        else
          description = "**disabled**"
        end
        require("snacks").notify.info(prefix .. "Flash search is " .. description)
      end,
      desc = "Toggle Flash Search",
    },
    init = function()
      -- Enable Flash search by default
      require("flash").toggle(true)
    end,
  },
}
