" Good .vimrc files
" http://people.mandriva.com/~rgarciasuarez/dotfiles/vimrc
" To see value of a variable inside vim, do (e.g.) "echo version"
set nocompatible

filetype off " per http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html

" Wow, this cleaned up my ~/.vim like you would not believe.
" http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen
" Note that pathogen must be called before built-in filetype plugin is
" loaded
call pathogen#infect()
call pathogen#helptags() " Generate help tags for every bundle

" RVM fix via http://rvm.beginrescueend.com/integration/vim/
set shell=/bin/sh

source $HOME/.vim/vundle.vim
source $HOME/.vim/statusline.vim
source $HOME/.vim/colorscheme.vim
source $HOME/.vim/options.vim
source $HOME/.vim/tabs.vim
source $HOME/.vim/backups.vim
source $HOME/.vim/mapping.vim
source $HOME/.vim/completion.vim
source $HOME/.vim/tabularizing.vim
source $HOME/.vim/functions.vim
source $HOME/.vim/rails_shortcuts.vim
" Allows % to switch between if/elsif/else/end, open/close XML tags, and
" more.
runtime macros/matchit.vim

source $HOME/.vim/autocommand.vim
source $HOME/.vim/ben.vim

" Turn on syntax highlighting when we have colors or gui is running
if &t_Co > 2 || has("gui_running") " &t_Co > 2 => we have colors
  syntax on
endif
