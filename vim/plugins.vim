" vim-plug: https://github.com/junegunn/vim-plug

set rtp+=/usr/local/opt/fzf

call plug#begin('~/.vim/bundle')

" Ruby/Rails/web development
Plug 'tpope/vim-rails', { 'for': 'rails' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
" Allow `cir` to change inside ruby block, etc
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' }
Plug 'kana/vim-textobj-user' " required for vim-textobj-rubyblock
Plug 'tpope/vim-rake', { 'for': 'ruby' }
Plug 'vim-coffee-script', { 'for': 'coffeescript' }
Plug 'gabebw/vim-spec-runner'
" Plug '~/code/personal/vim-spec-runner'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'mustache/vim-mustache-handlebars'
Plug 'slim-template/vim-slim', { 'for': 'slim' }
Plug 'tpope/vim-projectionist'

" Language-specific plugins
Plug 'keith/swift.vim', { 'for': 'swift' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'wting/rust.vim', { 'for': 'rust' }

" Plumbing that makes everything nicer, like lightline or git
Plug 'epmatsw/ag.vim'
Plug 'tComment'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'
Plug 'endwise.vim'
Plug 'kien/ctrlp.vim'
" Trim trailing whitespace on write
Plug 'derekprior/vim-trimmer'
Plug 'duggiefresh/vim-easydir'
Plug 'itchyny/lightline.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'bogado/file-line'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" gives you an `ae` text object, so `gcae` comments whole file
Plug 'kana/vim-textobj-entire'
Plug 'pbrisbin/vim-runfile'
Plug 'vim-scripts/Gundo'

" tmux
Plug 'christoomey/vim-tmux-runner'
Plug 'christoomey/vim-tmux-navigator'

" Silly stuff, but I like it
Plug 'junegunn/vim-emoji'
Plug 'gabebw/vim-rdio'
" Plug 'file:///Users/gabe/code/personal/vim-rdio'

" Markdown
Plug 'nicholaides/words-to-avoid.vim', { 'for': 'markdown' }
" It does more, but I'm mainly using this because it gives me markdown-aware
" `gx` so that `gx` works on [Markdown](links).
Plug 'christoomey/vim-quicklink', { 'for': 'markdown' }

" Haskell
Plug 'scrooloose/syntastic', { 'for': 'haskell' }
Plug 'pbrisbin/vim-syntax-shakespeare', { 'for': 'haskell' }
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }

" :Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

call plug#end()
