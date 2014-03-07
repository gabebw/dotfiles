set nocompatible

" Leader
let mapleader=" "

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Vundle goes first
source ~/.vim/vundle.vim

" Colorscheme needs to be before custom highlight groups in autocommand.vim
colorscheme jellybeans

source ~/.vim/options.vim
source ~/.vim/mapping.vim
source ~/.vim/completion.vim
source ~/.vim/test_runners.vim
source ~/.vim/rails_shortcuts.vim
source ~/.vim/statusline.vim
source ~/.vim/autocommand.vim
source ~/.vim/tmux.vim

runtime macros/matchit.vim
let g:ackprg = 'ag --nogroup --nocolor --column'
