set nocompatible

" Leader
let mapleader=" "

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Allows % to switch between if/elsif/else/end, open/close XML tags, and
" more.
runtime macros/matchit.vim

source ~/.vim/vundle.vim
source ~/.vim/options.vim
source ~/.vim/mapping.vim
source ~/.vim/completion.vim
source ~/.vim/tabularizing.vim
source ~/.vim/test_runners.vim
source ~/.vim/rails_shortcuts.vim
source ~/.vim/autocommand.vim

" Colorscheme
colorscheme jellybeans
