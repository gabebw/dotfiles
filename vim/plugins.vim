" vim-plug: https://github.com/junegunn/vim-plug

set rtp+=/usr/local/opt/fzf

" Web development
Plug 'vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'mustache/vim-mustache-handlebars'
Plug 'briancollins/vim-jst'

" Language-specific plugins
Plug 'sophacles/vim-processing'
Plug 'keith/swift.vim'
Plug 'fatih/vim-go'
Plug 'wting/rust.vim'
Plug 'vim-scripts/applescript.vim'
Plug 'vim-scripts/magic.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'cespare/vim-toml'
Plug 'chase/vim-ansible-yaml'

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
" Fuzzy-finder
Plug 'ctrlpvim/ctrlp.vim'
" Trim trailing whitespace on write
Plug 'derekprior/vim-trimmer'
" When editing deeply/nested/file, auto-create deeply/nested/ dirs
Plug 'duggiefresh/vim-easydir'
" Cool statusbar
Plug 'itchyny/lightline.vim'
Plug 'sonjapeterson/1989.vim'
" Easily navigate directories
Plug 'tpope/vim-vinegar'
" Make working with shell scripts nicer ("vim-unix")
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
" Make `.` work to repeat plugin actions too
Plug 'tpope/vim-repeat'
" Access to Vim's powerful undo-tree with :GundoShow
Plug 'vim-scripts/Gundo'
" Intelligently reopen files where you left off
Plug 'dietsche/vim-lastplace'
" Instead of always copying to the system clipboard, use `cp` (plus motions) to
" copy to the system clipboard. `cP` copies the current line. `cv` pastes.
Plug 'christoomey/vim-system-copy'
" gr to "go replace", "*griw to replace word with contents of system clipboard,
" etc
Plug 'vim-scripts/ReplaceWithRegister'

" Text objects
" required for all the vim-textobj-* plugins
Plug 'kana/vim-textobj-user'
" `ae` text object, so `gcae` comments whole file
Plug 'kana/vim-textobj-entire'
" `l` text object for the current line excluding leading whitespace
Plug 'kana/vim-textobj-line'

" Silly stuff, but I like it
" Now I can put emoji in my statusbar
Plug 'junegunn/vim-emoji'

" Markdown
Plug 'nicholaides/words-to-avoid.vim'
" It does more, but I'm mainly using this because it gives me markdown-aware
" `gx` so that `gx` works on [Markdown](links).
Plug 'christoomey/vim-quicklink'

" :Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
