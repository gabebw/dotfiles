" Auto commands {{{
if has("autocmd")
  " Turn on filetype detection, filetype plugins, and per-filetype indenting
  filetype plugin indent on
  " on opening the file, clear search-highlighting
  autocmd BufReadCmd set nohlsearch

  " Highlight trailing whitespace except on the current line
  autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
  autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
  highlight EOLWS ctermbg=red guibg=red

  " http://github.com/technicalpickles/pickled-vim/blob/master/home/.vimrc
  augroup myfiletypes
    " Clear old autocmds in group
    autocmd!
    " autoindent with two spaces, always expand tabs
    autocmd FileType ruby,eruby,yaml set autoindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
    " Include ! as a word character, so dw will delete all of e.g. gsub!,
    " and not leave the "!"
    autocmd FileType ruby set iskeyword+=!
    autocmd FileType javascript set autoindent shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType vim set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType cucumber set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    " Magic Python settings
    autocmd FileType python source ~/.vim/python

    " treat rackup files like ruby
    au BufRead,BufNewFile *.ru set ft=ruby
    au BufRead,BufNewFile Gemfile set ft=ruby
    au BufRead,BufNewFile .autotest set ft=ruby

    " .gitconfig and gitconfig are the same
    au BufRead,BufNewFile gitconfig set syntax=gitconfig

    autocmd BufRead ~/.dotfiles/extra/* set syntax=zsh ft=zsh
    autocmd BufRead ~/.dotfiles/zsh/* set syntax=zsh ft=zsh
    autocmd BufRead /usr/share/file/magic/* set syntax=magic
    autocmd BufRead /Users/gabe/Projects/thinkingtank/lib/*.rb set autoindent shiftwidth=4 softtabstop=4 tabstop=4 expandtab
    autocmd BufRead /Users/gabe/Projects/thinkingtank/lib/thinkingtank/*.rb set autoindent shiftwidth=4 softtabstop=4 tabstop=4 expandtab
  augroup END " END myfiletypes

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event
  " handler (happens when dropping a file on gvim).
  " via: http://github.com/jferris/config_files/blob/master/vimrc
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
endif " Auto commands }}}
