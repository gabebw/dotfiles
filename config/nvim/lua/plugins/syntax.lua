---@module "lazy.types"
---@type LazySpec[]
return {
  { "dag/vim-fish" },
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
  { "rust-lang/rust.vim" },
  { "vim-scripts/applescript.vim" },
  { "shmup/vim-sql-syntax" },
  { "tpope/vim-git" },
}
