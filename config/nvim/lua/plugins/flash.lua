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
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
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
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}
