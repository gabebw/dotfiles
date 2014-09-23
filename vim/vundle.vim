" Vundle; see https://github.com/gmarik/Vundle.vim
" To install, run :PluginInstall
" To update, run :PluginInstall!

set rtp+=~/.vim/bundle/Vundle.vim/

call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

Plugin 'epmatsw/ag.vim'
Plugin 'tComment'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'godlygeek/tabular'
" This fork of tslime fixes many things.
Plugin 'jgdavey/tslime.vim'
Plugin 'endwise.vim'
Plugin 'rake.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-coffee-script'
Plugin 'go.vim'
Plugin 'christoomey/vim-tmux-navigator'
" Trim trailing whitespace on write
Plugin 'derekprior/vim-trimmer'
Plugin 'skwp/greplace.vim'
Plugin 'dockyard/vim-easydir'
Plugin 'itchyny/lightline.vim'
" Words to avoid in tech writing
Plugin 'nicholaides/words-to-avoid.vim'
" Allow `cir` to change inside ruby block, etc
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
" Colorscheme
Plugin 'nanotech/jellybeans.vim'
Plugin 'gabebw/vim-spec-runner'
" Distraction-free writing
Plugin 'junegunn/goyo.vim'
Plugin 'henrik/vim-yaml-flattener'
Plugin 'bogado/file-line'
Plugin 'junegunn/vim-emoji'
Plugin 'christoomey/vim-sort-motion'
Plugin 'gabebw/pear_shaped'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-eunuch'

" :Gist
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

call vundle#end()
