" on opening the file, clear search-highlighting
autocmd BufReadCmd set nohlsearch

augroup myfiletypes
  autocmd!
  " Include ! as a word character, so dw will delete all of e.g. gsub!,
  " and not leave the "!"
  au FileType ruby,eruby,yaml set iskeyword+=!,?
  au FileType ruby,eruby,yaml set isfname=_,-,48-57,A-Z,a-z,/

  " Haskell has 4-space tabs
  au FileType haskell set shiftwidth=4

  " Tabs
  au FileType go set noexpandtab tabstop=4 shiftwidth=4

  " .step files are Ruby
  au BufRead,BufNewFile *.step setf ruby

  " .json.jbuilder files are Ruby
  au BufNewFile,BufRead *.json.jbuilder setf ruby

  " treat extra files like ruby
  au BufRead,BufNewFile *.ru,Gemfile,Guardfile,.simplecov setf ruby

  " It's Markdown, not modula2, you infernal machine
  au BufRead,BufNewFile *.md set syntax=markdown filetype=markdown
  au BufRead,BufNewFile *.coffee set syntax=coffee
  au BufRead,BufNewFile *.go setf go
  au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux

  " .gitconfig and gitconfig are the same
  au BufRead,BufNewFile gitconfig set syntax=gitconfig

  au BufRead /usr/share/file/magic/* set syntax=magic
augroup END

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
