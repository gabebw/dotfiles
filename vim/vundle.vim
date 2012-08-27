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

Bundle 'tsaleh/vim-matchit'
Bundle 'tComment'
Bundle 'Lokaltog/vim-powerline'

" tab completion
Bundle 'ervandew/supertab'

" Syntax and the like
Bundle 'pangloss/vim-javascript'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'tsaleh/vim-shoulda'
Bundle 'vim-ruby/vim-ruby'
Bundle 'godlygeek/tabular'
Bundle 'kchmck/vim-coffee-script'
Bundle 'Textile-for-VIM'
Bundle 'Markdown'

" Other
Bundle 'ack.vim'
Bundle 'greplace.vim'
Bundle 'snippetsEmu'
" This fixes a bunch of stuff.
Bundle 'jgdavey/tslime.vim'
Bundle 'endwise.vim'
Bundle 'file-line'
Bundle 'rake.vim'
Bundle 'kien/ctrlp.vim'

" Colorschemes
Bundle 'nanotech/jellybeans.vim'
