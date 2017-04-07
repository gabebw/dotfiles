" vim: set foldmethod=marker foldlevel=0:
" The folding settings above make the {{{ and }}} sections fold up.

" Leader is <Space>. Set it early because leader is used at the moment mappings
" are defined. Changing mapleader after a mapping is defined has no effect on
" the mapping.
let mapleader=" "

" ============================================================================
" PLUGINS {{{
" ===========================================================================

" vim-plug: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/bundle')
" Web development
Plug 'vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'mustache/vim-mustache-handlebars'
Plug 'briancollins/vim-jst'

" Ruby/Rails
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
" Allow `cir` to change inside ruby block, etc
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-projectionist'
Plug 'gabebw/vim-spec-runner'

" tmux
Plug 'christoomey/vim-tmux-runner'
Plug 'christoomey/vim-tmux-navigator'

" Haskell
Plug 'pbrisbin/vim-syntax-shakespeare'
Plug 'neovimhaskell/haskell-vim'
Plug 'Twinside/vim-hoogle'

" Syntax
Plug 'sophacles/vim-processing'
Plug 'keith/swift.vim'
Plug 'fatih/vim-go'
Plug 'wting/rust.vim'
Plug 'vim-scripts/applescript.vim'
Plug 'vim-scripts/magic.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'cespare/vim-toml'
Plug 'chase/vim-ansible-yaml'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'slim-template/vim-slim'

" Arduino
Plug 'stevearc/vim-arduino'

" Clojure
Plug 'guns/vim-clojure-static'
Plug 'luochen1990/rainbow'
" Remember to have a `lein repl` open in order for this to connect!
Plug 'tpope/vim-fireplace'

" Plumbing that makes everything nicer
" Fuzzy-finder
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
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
" When editing deeply/nested/file, auto-create deeply/nested/ dirs
Plug 'duggiefresh/vim-easydir'
" Cool statusbar
Plug 'itchyny/lightline.vim'
" Easily navigate directories
Plug 'tpope/vim-vinegar'
" Make working with shell scripts nicer ("vim-unix")
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
" Make `.` work to repeat plugin actions too
Plug 'tpope/vim-repeat'
" Intelligently reopen files where you left off
Plug 'dietsche/vim-lastplace'
" Instead of always copying to the system clipboard, use `cp` (plus motions) to
" copy to the system clipboard. `cP` copies the current line. `cv` pastes.
Plug 'christoomey/vim-system-copy'
" `vim README.md:10` opens README.md at the 10th line, rather than saying "No
" such file: README.md:10"
Plug 'bogado/file-line'

Plug 'flazz/vim-colorschemes'

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

call plug#end()
" }}}

" ============================================================================
" AUTOCOMMANDS {{{
" ===========================================================================
" on opening the file, clear search-highlighting
autocmd BufReadCmd set nohlsearch

" Without this, the next line copies a bunch of netrw settings like `let
" g:netrw_dirhistmax` to the system clipboard.
" I never use netrw, so disable its history.
let g:netrw_dirhistmax = 0

augroup vimrc
  autocmd!
  " Include ! as a word character, so dw will delete all of e.g. gsub!,
  " and not leave the "!"
  au FileType ruby,eruby,yaml set iskeyword+=!,?
  au FileType ruby,eruby,yaml set isfname=_,-,48-57,A-Z,a-z,/
  au BufNewFile,BufRead,BufWrite *.md,*.markdown,*.html syntax match Comment /\%^---\_.\{-}---$/
  autocmd VimResized * wincmd =
augroup END

" vim-rails + vim-projectionist
augroup rails_shortcuts
  autocmd!

  let g:rails_projections = {
      \ "config/routes.rb": { "command": "routes" },
      \ "spec/factories.rb": { "command": "factories" },
      \ "spec/features/*_spec.rb": { "command": "feature" },
      \ "app/services/*.rb": {
      \   "command": "service",
      \   "test": "spec/services/%s_spec.rb"
      \ },
      \ "app/jobs/*_job.rb": {
      \   "command": "job",
      \   "template": "class %SJob < ActiveJob::Job\nend",
      \   "test": [
      \     "spec/jobs/%s_job_spec.rb"
      \   ]
      \ },
  \ }

  autocmd User Rails nnoremap <Leader>m :Emodel<Space>
  autocmd User Rails nnoremap <Leader>c :Econtroller<Space>
  autocmd User Rails nnoremap <Leader>v :Eview<Space>
  autocmd User Rails nnoremap <Leader>u :Eunittest<Space>

  " Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
  let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
augroup END
" }}}

" ============================================================================
" COMPLETION {{{
" ===========================================================================
" The wild* settings are for _command_ (like `:color<TAB>`) completion, not for
" completion of words in files.
set wildmenu " enable a menu near the Vim command line
set wildignorecase " ignore case when completing file names and directories
set wildmode=list:longest,list:full

" completeopt values (default: "menu,preview")
" menu:    use popup menu to show possible completion
" menuone: Use the popup menu also when there is only one match.
"          Useful when there is additional information about the match,
"          e.g., what file it comes from.
" longest: only tab-completes up to the common elements, if any: " allows
"          you to hit tab, type to reduce options, hit tab to complete.
" preview: Show extra information about the currently selected completion in
"          the preview window. Only works in combination with "menu" or
"          "menuone".
set completeopt=menu,menuone,longest,preview
" }}}

" ============================================================================
" MAPPINGS {{{
" ===========================================================================
" Change the current working directory to the directory that the current file you are editing is in.
nnoremap <Leader>cd :cd %:p:h <CR>

" Opens a file with the current working directory already filled in so you have to specify only the filename.
nnoremap <Leader>e :e <C-R>=escape(expand("%:p:h"), ' ') . "/" <CR>

" Mnemonic: vgf = "vsplit gf"
nnoremap vgf :vsplit<CR>gf<CR>
" Mnemonic: sgf = "split gf"
nnoremap sgf :split<CR>gf<CR>

" Only have the current split and tab open
nnoremap <Leader>o :silent only\|silent tabonly<CR>

" Buffer navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h

" Movement
" move vertically by _visual_ line
nnoremap j gj
nnoremap k gk

" no ex mode
map Q <Nop>

" re-select the last pasted text
nnoremap gV V`]

" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Typo
nnoremap :Nohl :nohlsearch

" Automatically reselect text after in- or out-denting in visual mode
xnoremap < <gv
xnoremap > >gv

" Act like D and C
nnoremap Y y$

" ReRun last command
nnoremap <Leader>rr :write\|VtrSendCommand! !-1 <CR>
" }}}

" ============================================================================
" OPTIONS {{{
" ===========================================================================
" Maximum value is 10,000
set history=10000
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set ruler         " show cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set cursorline    " highlight the line the cursor is on
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set modelines=2   " inspect top/bottom 2 lines for modeline
set scrolloff=999 " When scrolling, keep cursor in the middle
set shiftround    " When at 3 spaces and I hit >>, go to 4, not 5.

" Don't ask me if I want to load changed files. The answer is always 'Yes'
set autoread

" https://github.com/thoughtbot/dotfiles/pull/170
" Automatically :write before commands such as :next or :!
" Saves keystrokes by eliminating writes before running tests, etc
" See :help 'autowrite' for more information
set autowrite

" When the type of shell script is /bin/sh, assume a POSIX-compatible shell for
" syntax highlighting purposes.
" More on why: https://github.com/thoughtbot/dotfiles/pull/471
let g:is_posix = 1

" Persistent undo
set undofile " Create FILE.un~ files for persistent undo
set undodir=~/.vim/undodir

if v:version > 703 || v:version == 703 && has("patch541")
  " Delete comment character when joining commented lines
  set formatoptions+=j
endif

" Let mappings and key codes timeout in 100ms
set ttimeout
set ttimeoutlen=100

" Create backups
set backup
set writebackup
set backupdir=~/.vim/backups
" setting backupskip to this to allow for 'crontab -e' using vim.
" thanks to: http://tim.theenchanter.com/2008/07/crontab-temp-file-must-be-ed
if has('unix')
  set backupskip=/tmp/*,/private/tmp/*"
endif

" Numbers
" With relativenumber and number set, shows relative number but has current
" number on current line.
set relativenumber
set number
set numberwidth=3

set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent
set copyindent " copy previous indentation on autoindenting
set showmatch " show matching parenthesis

" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase

" Open below and to the right, the same way you read a page
set splitbelow splitright

" File encoding and format
set fileencodings=utf-8,iso-8859-1
set fileformats=unix,mac,dos
set textwidth=80

" Meta characters
" Prepended to wrapped lines
set showbreak="@"

" Terminal.app keeps having a notification and "jumping" on the dock from Vim's
" bells, and this disables terminal Vim's bells.
" http://vim.wikia.com/wiki/Disable_beeping
set noerrorbells visualbell t_vb=

" Autocomplete with dictionary words when spell check is on
set complete+=kspell
set spellfile=$HOME/.vim/vim-spell-en.utf-8.add
" }}}

" ============================================================================
" PLUGINS {{{
" ===========================================================================

" ag.vim
" -----------------
nnoremap <Leader>g :Ag!<Space>
" K searches for word under cursor
nnoremap K :Ag! "\b<C-R>=expand("<cword>")<CR>\b"<CR>

" FZF
" -----------------
nnoremap <Leader>t :FZF<CR>

" gist.vim
" -----------------
let g:gist_open_browser_after_post = 1
" Copy the URL after gisting
let g:gist_clip_command = 'pbcopy'
" Post privately by default
let g:gist_post_private = 1

" vim-trimmer
" -----------------
let g:trimmer_repeated_lines_blacklist = ["conf"]

" vim-tmux-runner
" -----------------
" Open runner pane to the right, not to the bottom
let g:VtrOrientation = "h"
" Take up this percentage of the screen
let g:VtrPercentage = 30
" Attach to a specific pane
nnoremap <leader>va :VtrAttachToPane<CR>
" Zoom into tmux test runner pane. To get back to vim, use <C-a><C-p>
nnoremap <leader>zr :VtrFocusRunner<CR>

" vim-spec-runner
" -----------------
let g:spec_runner_dispatcher = 'VtrSendCommand! {command}'

" luochen1990/rainbow
" -----------------
if expand("%:e") ==# 'clj'
  let g:rainbow_active = 1
endif

let g:rainbow_conf = {
  \ 'ctermfgs': [
  \   'brown',
  \   'Darkblue',
  \   'darkgray',
  \   'darkgreen',
  \   'darkcyan',
  \   'darkred',
  \   'darkmagenta',
  \   'brown',
  \   'gray',
  \   'black',
  \   'darkmagenta',
  \   'Darkblue',
  \   'darkgreen',
  \   'darkcyan',
  \   'darkred',
  \   'red',
  \ ]
\ }
" }}}

" ============================================================================
" STATUSLINE {{{
" ===========================================================================
" always display status line
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night_Eighties',
      \ 'active': {
      \   'left': [
      \             ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'myfilename', 'modified']
      \           ]
      \ },
      \ 'component': {
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
      \   'readonly': '%{(&filetype!="help" && &readonly) ? "RO" : ""}',
      \ },
      \ 'component_function': {
      \   'myfilename': 'LightLineFilename',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ }
\ }

function! LightLineFilename()
  let git_root = fnamemodify(fugitive#extract_git_dir(expand("%:p")), ":h")

  if expand("%:t") == ""
    return "[No Name]"
  elseif git_root != "" && git_root != "."
    return substitute(expand("%:p"), git_root . "/", "", "")
  else
    return expand("%:p")
  endif
endfunction
" }}}

" ============================================================================
" TABS {{{
" ===========================================================================
" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab
" }}}

runtime macros/matchit.vim

" vim-plug loads all the filetype, syntax and colorscheme files, so turn them on
" _after_ loading plugins.
filetype plugin indent on
syntax enable
silent! colorscheme l80snight
