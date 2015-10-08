" vim-plug: https://github.com/junegunn/vim-plug

set rtp+=/usr/local/opt/fzf

" Ruby/Rails/web development
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
" Allow `cir` to change inside ruby block, etc
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'kana/vim-textobj-user' " required for vim-textobj-rubyblock
Plug 'tpope/vim-rake'
Plug 'vim-coffee-script'
Plug 'gabebw/vim-spec-runner'
" Plug '~/code/personal/vim-spec-runner'
Plug 'pangloss/vim-javascript'
Plug 'mustache/vim-mustache-handlebars'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-projectionist'

" Language-specific plugins
Plug 'keith/swift.vim'
Plug 'fatih/vim-go'
Plug 'wting/rust.vim'

" Plumbing that makes everything nicer
" :Ag is like :grep but with `ag`
Plug 'rking/ag.vim'
" Easily comment/uncomment lines in many languages
Plug 'tomtom/tcomment_vim'
" <Tab> indents or triggers autocomplete, smartly
Plug 'ervandew/supertab'
" Git bindings
Plug 'tpope/vim-fugitive'
" Auto-add `end` in Ruby, `endfunction` in Vim, etc
Plug 'tpope/vim-endwise'
Plug 'kien/ctrlp.vim'
" Trim trailing whitespace on write
Plug 'derekprior/vim-trimmer'
" When editing deeply/nested/file, auto-create deeply/nested/ dirs
Plug 'duggiefresh/vim-easydir'
" Cool statusbar
Plug 'itchyny/lightline.vim'
" Colorscheme. Looks great with Tomorrow Night Eighties.terminal theme in this repo.
Plug 'nanotech/jellybeans.vim'
" Easily navigate directories
Plug 'tpope/vim-vinegar'
" Make working with shell scripts nicer ("vim-unix")
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
" Make `.` work to repeat plugin actions too
Plug 'tpope/vim-repeat'
" Gives you an `ae` text object, so `gcae` comments whole file
Plug 'kana/vim-textobj-entire'
" Access to Vim's powerful undo-tree with :GundoShow
Plug 'vim-scripts/Gundo'
" Intelligently reopen files where you left off
Plug 'dietsche/vim-lastplace'

" Silly stuff, but I like it
" Now I can put emoji in my statusbar
Plug 'junegunn/vim-emoji'
" Control Rdio from Vim
Plug 'gabebw/vim-rdio'
" Plug 'file:///Users/gabe/code/personal/vim-rdio'

" Markdown
Plug 'nicholaides/words-to-avoid.vim'
" It does more, but I'm mainly using this because it gives me markdown-aware
" `gx` so that `gx` works on [Markdown](links).
Plug 'christoomey/vim-quicklink'

" :Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
