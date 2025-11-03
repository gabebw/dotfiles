return {
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
  {
    "airblade/vim-localorie",
    init = function()
      vim.cmd [[
        autocmd BufEnter *.yml nmap <buffer> <Leader>y :let @" = substitute(localorie#expand_key(), '^en\.', '', '')<CR>
      ]]
    end,
  },
}
