" Vundle; see https://github.com/gmarik/vundle
" To install, run :BundleInstall
" To update, run :BundleInstall!
set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()

" Bundles:
" let Vundle manage Vundle
Bundle 'gmarik/vundle'

Bundle 'tsaleh/vim-matchit'
Bundle 'tComment'
Bundle 'Lokaltog/vim-powerline'

" tab completion
Bundle 'ervandew/supertab'

" Syntax and the like
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'vim-ruby/vim-ruby'
Bundle 'godlygeek/tabular'

" Other
Bundle 'ack.vim'

" This fork of tslime fixes many things.
Bundle 'jgdavey/tslime.vim'
Bundle 'endwise.vim'
Bundle 'rake.vim'
Bundle 'kien/ctrlp.vim'

" Colorschemes
Bundle 'nanotech/jellybeans.vim'
