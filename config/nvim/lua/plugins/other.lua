return {
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

  -- Markdown
  { "tpope/vim-markdown" },
  { "nicholaides/words-to-avoid.vim", ft = "markdown" },
  -- It does more, but I'm mainly using this because it gives me markdown-aware
  -- `gx` so that `gx` works on [Markdown](links).
  { "christoomey/vim-quicklink", ft = "markdown" },
  -- Make `gx` work on 'gabebw/dotfiles' too
  { "gabebw/vim-github-link-opener", branch = "main" },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  { "airblade/vim-localorie" },
  { "tpope/vim-projectionist" },
  { "christoomey/vim-tmux-navigator" },
  { "tpope/vim-rake" },
}
