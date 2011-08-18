" Vundle; see https://github.com/gmarik/vundle
" To install, run :BundleInstall
" To update, run BundleInstall!
" **DO NOT** put a call to BundleInstall in your vimrc! It'll recurse A LOT
" and things will get weird.
set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()

" Bundles:
" let Vundle manage Vundle
Bundle 'gmarik/vundle'
Bundle 'jquery'
Bundle 'pydoc'
" Bundle 'pyflakes'
Bundle 'scrooloose/nerdtree'
Bundle 'tsaleh/vim-matchit'
Bundle 'tComment'

" tab completion
Bundle 'ervandew/supertab'

" Syntax and the like
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rails'
Bundle 'tsaleh/vim-shoulda'
Bundle 'vim-ruby/vim-ruby'
Bundle 'godlygeek/tabular'
Bundle 'ack.vim'

" Colorschemes
Bundle 'Railscasts-Theme-GUIand256color'
Bundle 'vividchalk.vim'
Bundle 'molokai'

" Light
"   set background=light
"   colorscheme solarized
" Dark
"   set background=dark
"   colorscheme solarized
Bundle 'altercation/vim-colors-solarized'
