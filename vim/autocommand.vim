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
    au FileType ruby,eruby,yaml set autoindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
    " Include ! as a word character, so dw will delete all of e.g. gsub!,
    " and not leave the "!"
    au FileType ruby,eruby,yaml set iskeyword+=!,?
    au FileType ruby,eruby,yaml set isfname=_,-,48-57,A-Z,a-z,/
    au FileType javascript set autoindent shiftwidth=2 softtabstop=2 expandtab
    au FileType vim set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    au FileType cucumber set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab

    " treat extra files like ruby
    au BufRead,BufNewFile *.ru,Gemfile,Guardfile,.simplecov setf ruby

    " It's Markdown, not modula2, you infernal machine
    au BufRead,BufNewFile *.md set syntax=markdown filetype=markdown

    " .gitconfig and gitconfig are the same
    au BufRead,BufNewFile gitconfig set syntax=gitconfig

    au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux

    au BufRead /usr/share/file/magic/* set syntax=magic

    " Indent text inside <p> tags
    autocmd TabEnter,WinEnter,BufWinEnter *.html,*.html.erb let g:html_indent_tags = g:html_indent_tags.'\|p'
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
