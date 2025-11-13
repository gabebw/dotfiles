-- Plumbing that makes everything nicer
return {
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
  -- Easily navigate directories
  { "tpope/vim-vinegar" },
  -- Make working with shell scripts nicer ("vim-unix")
  { "tpope/vim-eunuch" },
  {
    "tpope/vim-surround",
    config = function()
      -- Reserve `yS` for flash.nvim
      local mappings = {
        "yS",
        "ySs",
        "ySS",
      }
      for _, v in pairs(mappings) do
        vim.keymap.del("n", v)
      end
    end,
  },
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
    "xolox/vim-easytags",
    dependencies = { "xolox/vim-misc" },
    init = function()
      vim.g.easytags_events = {}
    end,
  },

  -- Text objects
  -- `ae` text object, so `gcae` comments whole file
  { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },
  -- `l` text object for the current line excluding leading whitespace
  { "kana/vim-textobj-line", dependencies = { "kana/vim-textobj-user" } },
}
