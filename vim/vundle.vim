" Vundle; see https://github.com/gmarik/Vundle.vim
" To install, run :PluginInstall
" To update, run :PluginInstall!

set rtp+=~/.vim/bundle/Vundle.vim/
set rtp+=/usr/local/opt/fzf

call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

Plugin 'epmatsw/ag.vim'
Plugin 'tComment'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'endwise.vim'
Plugin 'tpope/vim-rake'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-coffee-script'
Plugin 'christoomey/vim-tmux-navigator'
" Trim trailing whitespace on write
Plugin 'derekprior/vim-trimmer'
Plugin 'duggiefresh/vim-easydir'
Plugin 'itchyny/lightline.vim'
Plugin 'nicholaides/words-to-avoid.vim'
" Allow `cir` to change inside ruby block, etc
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'nanotech/jellybeans.vim'
Plugin 'gabebw/vim-spec-runner'
Plugin 'bogado/file-line'
Plugin 'junegunn/vim-emoji'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-surround'
Plugin 'gabebw/vim-rdio'
" Plugin 'file:///Users/gabe/code/personal/vim-rdio'
Plugin 'christoomey/vim-tmux-runner'
Plugin 'pbrisbin/vim-syntax-shakespeare'
Plugin 'Keithbsmiley/swift.vim'
Plugin 'fatih/vim-go'
Plugin 'wting/rust.vim'
Plugin 'tpope/vim-repeat'
Plugin 'pangloss/vim-javascript'
" It does more, but I'm mainly using this because it gives me markdown-aware
" `gx` so that `gx` works on [Markdown](links).
Plugin 'christoomey/vim-quicklink'

" :Gist
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'

call vundle#end()
