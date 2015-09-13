" vim-plug: https://github.com/junegunn/vim-plug

set rtp+=/usr/local/opt/fzf

call plug#begin('~/.vim/bundle')

Plug 'epmatsw/ag.vim'
Plug 'tComment'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails', { 'for': 'rails' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'endwise.vim'
Plug 'tpope/vim-rake'
Plug 'kien/ctrlp.vim'
Plug 'vim-coffee-script', { 'for': 'coffeescript' }
Plug 'christoomey/vim-tmux-navigator'
" Trim trailing whitespace on write
Plug 'derekprior/vim-trimmer'
Plug 'duggiefresh/vim-easydir'
Plug 'itchyny/lightline.vim'
Plug 'nicholaides/words-to-avoid.vim'
" Allow `cir` to change inside ruby block, etc
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'nanotech/jellybeans.vim'
Plug 'gabebw/vim-spec-runner'
" Plug '~/code/personal/vim-spec-runner'
Plug 'bogado/file-line'
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'gabebw/vim-rdio'
" Plug 'file:///Users/gabe/code/personal/vim-rdio'
Plug 'christoomey/vim-tmux-runner'
Plug 'Keithbsmiley/swift.vim', { 'for': 'swift' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'wting/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-repeat'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
" It does more, but I'm mainly using this because it gives me markdown-aware
" `gx` so that `gx` works on [Markdown](links).
Plug 'christoomey/vim-quicklink', { 'for': 'markdown' }
Plug 'tpope/vim-projectionist'
Plug 'mustache/vim-mustache-handlebars'
Plug 'slim-template/vim-slim', { 'for': 'slim' }
" gives you an `ae` text object, so `gcae` comments whole file
Plug 'kana/vim-textobj-entire'
Plug 'pbrisbin/vim-runfile'
Plug 'vim-scripts/Gundo'

" Haskell
Plug 'scrooloose/syntastic', { 'for': 'haskell' }
Plug 'pbrisbin/vim-syntax-shakespeare', { 'for': 'haskell' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }

" :Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

call plug#end()
