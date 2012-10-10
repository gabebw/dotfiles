" Good .vimrc files
" http://people.mandriva.com/~rgarciasuarez/dotfiles/vimrc
" To see value of a variable inside vim, do (e.g.) "echo version"
set nocompatible

filetype off " per http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html

source ~/.vim/vundle.vim
source ~/.vim/statusline.vim
source ~/.vim/colorscheme.vim
source ~/.vim/options.vim
source ~/.vim/tabs.vim
source ~/.vim/mapping.vim
source ~/.vim/completion.vim
source ~/.vim/tabularizing.vim
source ~/.vim/test_runners.vim
source ~/.vim/rails_shortcuts.vim
" Allows % to switch between if/elsif/else/end, open/close XML tags, and
" more.
runtime macros/matchit.vim

source ~/.vim/autocommand.vim
