" Vundle; see https://github.com/gmarik/vundle
" To install, run :BundleInstall
" To update, run :BundleInstall!
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles:
" let Vundle manage Vundle
Bundle 'gmarik/vundle'

Bundle 'epmatsw/ag.vim'
Bundle 'tsaleh/vim-matchit'
Bundle 'tComment'
Bundle 'ervandew/supertab'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'vim-ruby/vim-ruby'
Bundle 'godlygeek/tabular'
" This fork of tslime fixes many things.
Bundle 'jgdavey/tslime.vim'
Bundle 'endwise.vim'
Bundle 'rake.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'vim-coffee-script'
Bundle 'go.vim'

" Colorschemes
Bundle 'nanotech/jellybeans.vim'
