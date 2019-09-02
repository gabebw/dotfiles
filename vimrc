" vim: foldmethod=marker foldlevel=1
" The folding settings above make the {{{ and }}} sections fold up.

" Disable Vi compatibility.
set nocompatible

" Leader is <Space>. Set it early because leader is used at the moment mappings
" are defined. Changing mapleader after a mapping is defined has no effect on
" the mapping.
let mapleader=' '

" ============================================================================
" AUTOCOMMANDS {{{
" ===========================================================================
" on opening the file, clear search-highlighting
autocmd BufReadCmd set nohlsearch

" Without this, the next line copies a bunch of netrw settings like `let
" g:netrw_dirhistmax` to the system clipboard.
" I never use netrw, so disable its history.
let g:netrw_dirhistmax = 0

" Highlight the current line, only for the buffer with focus
augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

augroup vimrc
  autocmd!
  " Include ! as a word character, so dw will delete all of e.g. gsub!,
  " and not leave the "!"
  au FileType ruby,eruby,yaml set iskeyword+=!,?
  au BufNewFile,BufRead,BufWrite *.md,*.markdown,*.html syntax match Comment /\%^---\_.\{-}---$/
  autocmd VimResized * wincmd =

  " Re-source vimrc whenever it changes
  autocmd BufWritePost vimrc,$MYVIMRC nested if expand("%") !~ 'fugitive' | source % | endif
augroup END

" vim-rails + vim-projectionist
augroup rails_shortcuts
  autocmd!
  autocmd User Rails nnoremap <Leader>m :Emodel<Space>
  autocmd User Rails nnoremap <Leader>c :Econtroller<Space>
  autocmd User Rails nnoremap <Leader>v :Eview<Space>
  autocmd User Rails nnoremap <Leader>u :Eunittest<Space>
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

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Toggle quickfix
nnoremap yoq :<C-R>=QuickFixIsOpen() ? "cclose" : "copen"<CR><CR>

" Opens a file with the current working directory already filled in so you have to specify only the filename.
nnoremap <Leader>e :e <C-R>=escape(expand('%:p:h'), ' ') . '/' <CR>

" Mnemonic: vgf = "vsplit gf"
nnoremap vgf :vsplit<CR>gf
" Mnemonic: sgf = "split gf"
nnoremap sgf :split<CR>gf
" Mnemonic: tgf = "tab gf"
nnoremap tgf <C-w>gf

" OK, so, in this comment, | is where the Vim cursor is.
" Given this situation:
"     user.fo|o!
" When I press <C-]> to go to the `foo!` tag, for some reason it acts as if the
" cursor is on `user` and goes to the `user` tag.
"
" To fix this, use `<cword>` to select the word under the cursor and go to it
" directly.
nnoremap <C-]>      :tag <C-R>=expand('<cword>')<CR><CR>
nnoremap <C-W><C-]> :stag <C-R>=expand('<cword>')<CR><CR>

" Searching
" -----------------
command! -nargs=+ -complete=file -bar Grep silent! grep! <args> | copen 10 | redraw!
command! -nargs=+ -complete=file -bar GrepWithoutTests silent! grep! --glob '!spec/' <args> | copen 10 | redraw!

function! FindLocationOf(needle)
  let l:path_and_line_number = split(system('find-location-of ' . a:needle), ':')
  if v:shell_error == 0
    let l:path = path_and_line_number[0]
    let l:line_number = path_and_line_number[1]
    call MaybeTabedit(path)
    execute line_number
  else
    echom 'Something went wrong'
  endif
endfunction
command! -nargs=1 -bar Viw call FindLocationOf(<q-args>)

function! CharacterUnderCursor()
  return nr2char(strgetchar(getline('.')[col('.') - 1:], 0))
endfunction

function! SearchableWordNearCursor()
  " <cword> tries a little too hard to find a word.
  " Given this (cursor at |):
  " hello | there
  " Then the <cword> is `there`.
  " Thus, we use `CharacterUnderCursor` (which is precise) to determine if we're
  " on a word at all.
  if CharacterUnderCursor() =~? '^\s$'
    return ''
  else
    let word_under_cursor = expand('<cword>')
    " Sometimes the word under the cursor includes punctuation, in which case
    " '\bWORD!\b' will fail because \b is a word boundary and we have non-word
    " characters in WORD. So, remove them. This results in a less-precise match
    " (it'll find WORD as well as WORD!, for example), but is better than getting
    " zero results.
    return substitute(word_under_cursor, '[$!?]', '', 'g')
  endif
endfunction

function! SearchForWordUnderCursor()
  let searchable_word = SearchableWordNearCursor()

  if len(searchable_word) == 0
    " All whitespace or empty, don't search for it because there will be
    " thousands of (useless) results.
    echo 'Not searching for whitespace or empty string'
  else
    " two single quotes in a row = one single quote, like \' in other languages
    execute 'Grep ''\b' . shellescape(searchable_word) . '\b'''
  end
endfunction

nnoremap K :call SearchForWordUnderCursor()<CR>
nnoremap <Leader>g :Grep<Space>

" Close all other windows in this tab, and don't error if this is the only one
nnoremap <Leader>o :silent only<CR>

" Movement
" move vertically by _visual_ line
nnoremap j gj
nnoremap k gk

" no ex mode
map Q <Nop>

" re-select the last pasted text
nnoremap gV V`]

" edit vimrc/zshrc and load vimrc bindings
function! MaybeTabedit(file)
  let new_empty_file = line('$') == 1 && getline(1) == '' && bufname('%') == ''
  if bufname('%') ==# a:file
    " Already editing vimrc, do nothing
  elseif new_empty_file
    " If this is an empty file, just replace it with the file to edit
    execute 'edit ' . a:file
  else
    execute 'tabedit ' . a:file
  endif
endfunction
nnoremap <leader>ev :call MaybeTabedit($MYVIMRC)<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>q :call MaybeTabedit('$HOME/.zshrc')<CR>

" Typo
nnoremap :Nohl :nohlsearch

" Automatically reselect text after in- or out-denting in visual mode
xnoremap < <gv
xnoremap > >gv

" Big Yank to clipboard
nnoremap Y "*yiw

" ReRun last command
nnoremap <Leader>rr :write\|VtrSendCommand! !-1 <CR>
nnoremap <Leader>vs :VtrSendCommand!<Space>
nnoremap <Leader>vd :VtrSendCtrlD<CR>
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
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set modelines=2   " inspect top/bottom 2 lines for modeline
set scrolloff=1   " When scrolling, keep cursor in the middle
set shiftround    " When at 3 spaces and I hit >>, go to 4, not 5.
set colorcolumn=+0 " Set to the textwidth

" Enforce italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

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

if v:version > 703 || v:version == 703 && has('patch541')
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

set listchars=tab:>-,trail:~

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
set showbreak='@'

" Terminal.app keeps having a notification and "jumping" on the dock from Vim's
" bells, and this disables terminal Vim's bells.
" http://vim.wikia.com/wiki/Disable_beeping
set noerrorbells visualbell t_vb=

" Autocomplete with dictionary words when spell check is on
set complete+=kspell
set spellfile=$HOME/.vim/vim-spell-en.utf-8.add

set grepprg=rg\ --hidden\ --vimgrep\ --with-filename\ --max-columns\ 200\ --case-sensitive
set grepformat=%f:%l:%c:%m
" }}}

" ============================================================================
" PLUGIN OPTIONS {{{
" ===========================================================================

" gundo
" -----
" Without this, Gundo won't run because Python 2 isn't installed.
let g:gundo_prefer_python3 = 1

" peekaboo
" --------
let g:peekaboo_window	= 'vert bo 50new'

" Ale
" --------

augroup Ale
  autocmd!
  " ALE linting events
  set updatetime=1000
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_linters = {}
  " Run everything except rails_best_practices, which runs multiple processes
  " and keeps all of my CPU cores at 100%.
  let g:ale_linters.ruby = ['brakeman', 'reek', 'rubocop', 'ruby']
  let g:ale_linters = {'rust': ['cargo']}
  let g:ale_rust_cargo_use_clippy = 1

  let g:ale_linters.javascript = ['eslint']
  autocmd CursorHold * call ale#Queue(0)
  autocmd InsertLeave * call ale#Queue(0)
augroup END
" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" FZF
" -----------------
" This prefixes all FZF-provided commands with 'Fzf' so I can easily find cool
" FZF commands and not have to remember 'Colors' and 'History/' etc.
let g:fzf_command_prefix = 'Fzf'

nnoremap <Leader>t :FZF<CR>
nnoremap <Leader>b :FzfBuffers<CR>

" easytags
" ----------
let g:easytags_async = 1

" rails.vim
"----------
let g:rails_projections = {
    \ 'config/routes.rb': { 'command': 'routes' },
    \ 'app/admin/*.rb': {
    \   'command': 'admin',
    \   'alternate': 'spec/controllers/admin/{singular}_controller_spec.rb',
    \ },
    \ 'spec/controllers/admin/*_controller_spec.rb': {
    \   'alternate': 'app/admin/{plural}.rb',
    \ },
    \ 'spec/factories/*.rb': { 'command': 'factories' },
    \ 'spec/factories.rb': { 'command': 'factories' },
    \ 'spec/features/*_spec.rb': { 'command': 'feature' },
    \ 'config/locales/en/*.yml': {
    \   'command': 'tran',
    \   'template': 'en:\n  {underscore|plural}:\n    ',
    \ },
    \ 'app/services/*.rb': {
    \   'command': 'service',
    \   'test': 'spec/services/{}_spec.rb'
    \ },
    \ 'script/datamigrate/*.rb': {
    \   'command': 'datamigrate',
    \   'template': '#!/usr/bin/env rails runner\n\n',
    \ },
    \ 'app/jobs/*_job.rb': {
    \   'command': 'job',
    \   'template': 'class {camelcase|capitalize|colons}Job < ActiveJob::Job\n  def perform(*)\n  end\nend',
    \   'test': [
    \     'spec/jobs/{}_job_spec.rb'
    \   ]
    \ },
\ }

" gist.vim
" -----------------
let g:gist_open_browser_after_post = 1
" Copy the URL after gisting
let g:gist_clip_command = 'pbcopy'
" Post privately by default
let g:gist_post_private = 1

" fugitive
" --------
" Get a direct link to the current line (with specific commit included!) and
" copy it to the system clipboard
command! GitLink silent! .Gbrowse!
command! GitLinkFile silent! 0Gbrowse!
" Open the commit hash under the cursor, in GitHub
autocmd FileType fugitiveblame nnoremap <buffer> <silent> gb :Gbrowse <C-r><C-w><CR>

" vim-trimmer
" -----------------
" filetypes, check with :set ft?
let g:trimmer_repeated_lines_blacklist_file_types = ['conf', 'python', 'eruby.yaml']
let g:trimmer_repeated_lines_blacklist_file_base_names = ['schema.rb', 'structure.sql']

" vim-tmux-runner
" -----------------
" Open runner pane to the right, not to the bottom
let g:VtrOrientation = 'h'
" Take up this percentage of the screen
let g:VtrPercentage = 30
" Attach to a specific pane
nnoremap <leader>va :VtrAttachToPane<CR>
" Zoom into tmux test runner pane. To get back to vim, use <C-a><C-p>
nnoremap <leader>zr :VtrFocusRunner<CR>

" Test running
" -----------------
nnoremap <Leader>l :w<CR>:TestNearest<CR>:redraw!<CR>
nnoremap <Leader>a :w<CR>:TestFile<CR>:redraw!<CR>
let test#strategy = 'vtr'
let test#ruby#rspec#options = {
      \ 'nearest': '--format documentation',
      \ 'file':    '--format documentation',
      \ }

" vim-ruby
" -----------------
let ruby_no_expensive = 1

" vim-jsx
" -------
" Don't require a .jsx extension
let g:jsx_ext_required = 0

" luochen1990/rainbow
" -----------------
if expand('%:e') ==# 'clj'
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
" Don't show `-- INSERT --` below the statusbar since it's in the statusbar
set noshowmode

let g:lightline = {}
let g:lightline.component = {}
let g:lightline.component_function = {}
let g:lightline.component_visible_condition = {}
let g:lightline.tabline = {}

let g:lightline.colorscheme = 'darcula'
let g:lightline.active = {}
let g:lightline.active.left = [
      \ ['mode', 'paste'],
      \ ['fugitive', 'readonly', 'myfilename', 'modified']
      \ ]
let g:lightline.component.fugitive = '%{exists("*fugitive#head")?fugitive#head():""}'
let g:lightline.component.readonly = '%{(&filetype!="help" && &readonly) ? "RO" : ""}'
let g:lightline.component_function.myfilename = 'LightLineFilename'
let g:lightline.component_visible_condition.readonly = '(&filetype!="help"&& &readonly)'
let g:lightline.component_visible_condition.fugitive = '(exists("*fugitive#head") && ""!=fugitive#head())'
let g:lightline.tabline.right = [] " Disable the 'X' on the far right

function! LightLineFilename()
  let git_root = fnamemodify(fugitive#extract_git_dir(expand('%:p')), ':h')

  if expand('%:t') == ''
    return '[No Name]'
  elseif git_root != '' && git_root != '.'
    return substitute(expand('%:p'), git_root . '/', '', '')
  else
    return expand('%:p')
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

" ============================================================================
" FUNCTIONS and COMMANDS {{{
" ===========================================================================
function! StripTrailingNewline(string)
    return substitute(a:string, '\n\+$', '', '')
endfunction

function! QuickFixIsOpen()
  let l:result = filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')
  return !empty(l:result)
endfunction

function! ExpandShortGitShaIntoFullGitSha()
  let short_sha = expand("<cword>")
  let full_sha = StripTrailingNewline(system('git rev-parse ' . short_sha))
  " Delete and replace SHA
  exec 'normal! ciw' . full_sha
endfunction

function! s:EnsureNothingConflictsWithGrep()
  " I type `<Leader>g` to pop up `:Grep ` then quickly start typing my search
  " term. When (e.g.) `<Leader>gc` exists, I have to pause after `<Leader>g`
  " when I'm searching for a term that starts with 'c'. That's hard to remember,
  " so instead I'm ensuring that I never conflic with grep.
  let alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
        \ 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

  for letter in alphabet
    if !empty(maparg('<Leader>g'.letter, 'n'))
      echoerr 'You mapped something to <Leader>g'.letter.', which will mess up grep'
    endif
  endfor
endfunction

command! CopyPath :let @+ = expand('%:p')
" }}}

" ============================================================================
" PLUGINS {{{
" ===========================================================================
" vim-plug: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/bundle')

" JavaScript
Plug 'vim-scripts/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mustache/vim-mustache-handlebars'
Plug 'briancollins/vim-jst'
" To format JS or CSS, add `// @format` at the top:
" https://prettier.io/docs/en/vim.html#vim-prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'scss', 'json', 'graphql'] }
Plug 'leafgarland/typescript-vim'

" Ruby/Rails
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
" Allow `cir` to change inside ruby block, etc
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rake', { 'for': ['ruby'] }
Plug 'tpope/vim-projectionist'
Plug 'janko-m/vim-test'

" tmux
Plug 'christoomey/vim-tmux-runner'
Plug 'christoomey/vim-tmux-navigator'

" Haskell
Plug 'pbrisbin/vim-syntax-shakespeare'
Plug 'neovimhaskell/haskell-vim'
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }

" Syntax
Plug 'sophacles/vim-processing'
Plug 'keith/swift.vim'
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/applescript.vim'
Plug 'vim-scripts/magic.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'cespare/vim-toml'
Plug 'chase/vim-ansible-yaml'
Plug 'chr4/nginx.vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'slim-template/vim-slim'
Plug 'shmup/vim-sql-syntax'
Plug 'hashivim/vim-terraform'

" Arduino
Plug 'stevearc/vim-arduino'

" Clojure
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'luochen1990/rainbow', { 'for': 'clojure' }
" Remember to have a `lein repl` open in order for this to connect!
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'tpope/vim-classpath', { 'for': 'clojure' }

" Plumbing that makes everything nicer
" Fuzzy-finder
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
" Easily comment/uncomment lines in many languages
Plug 'tomtom/tcomment_vim'
" <Tab> indents or triggers autocomplete, smartly
Plug 'ervandew/supertab'
" Cool commands and syntax highlighting for Vim. The GitHub version is a little ahead of the
" official Vim versions, so use the GitHub version.
Plug 'tpope/vim-git'
" Git bindings
Plug 'tpope/vim-fugitive'
" The Hub to vim-fugitive's git
Plug 'tpope/vim-rhubarb'
" :Gist
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'
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
Plug 'farmergreg/vim-lastplace'
" Instead of always copying to the system clipboard, use `cp` (plus motions) to
" copy to the system clipboard. `cP` copies the current line. `cv` pastes.
Plug 'christoomey/vim-system-copy'
" `vim README.md:10` opens README.md at the 10th line, rather than saying "No
" such file: README.md:10"
Plug 'bogado/file-line'
Plug 'christoomey/vim-sort-motion'
Plug 'flazz/vim-colorschemes'
Plug 'sjl/gundo.vim'
Plug 'xolox/vim-misc' | Plug 'xolox/vim-easytags'
Plug 'w0rp/ale'
" Easily inspect registers exactly when you need them
" https://github.com/junegunn/vim-peekaboo
Plug 'junegunn/vim-peekaboo'
Plug 'AndrewRadev/splitjoin.vim'

" Text objects
" required for all the vim-textobj-* plugins
Plug 'kana/vim-textobj-user'
" `ae` text object, so `gcae` comments whole file
Plug 'kana/vim-textobj-entire'
" `l` text object for the current line excluding leading whitespace
Plug 'kana/vim-textobj-line'

" Markdown
Plug 'nicholaides/words-to-avoid.vim', { 'for': 'markdown' }
" It does more, but I'm mainly using this because it gives me markdown-aware
" `gx` so that `gx` works on [Markdown](links).
Plug 'christoomey/vim-quicklink', { 'for': 'markdown' }
" Make `gx` work on 'gabebw/dotfiles' too
Plug 'gabebw/vim-github-link-opener'

if filereadable($HOME . '/.vimrc.bundles.local')
  source $HOME/.vimrc.bundles.local
endif

call plug#end()
" }}}

runtime macros/matchit.vim

" vim-plug loads all the filetype, syntax and colorscheme files, so turn them on
" _after_ loading plugins.
filetype plugin indent on
syntax enable
silent! colorscheme Tomorrow-Night-Bright

function! SyntaxItem()
  " https://vim.fandom.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
  " highest / transparent / lowest
  return 'hi<' .
        \ synIDattr(synID(line('.'), col('.'), 1), 'name') . '> trans<' .
        \ synIDattr(synID(line('.'), col('.'), 0), 'name') . '> lo<' .
        \ synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') . '>'
endfunction

function! s:BetterColorschemeSettings()
  hi clear SpellBad
  hi clear ALEStyleError
  hi clear ALEError
  hi clear ALEWarning
  hi SpellBad cterm=underline ctermfg=red
  " Highlight ruby TODO etc in red
  hi rubyTodo cterm=underline ctermfg=red
  " Make some things italic
  hi! Comment term=italic cterm=italic gui=italic
  hi! Constant term=italic cterm=italic gui=italic
  hi! link gitCommitComment Comment
  hi! link gitCommitHeader Comment
endfunction

call <SID>BetterColorschemeSettings()
augroup Colorscheme
  au!
  " Re-run these settings whenever colorscheme changes, in order to re-overwrite
  " whatever the colorscheme sets
  autocmd ColorScheme * call <SID>BetterColorschemeSettings()
augroup END

if filereadable('.git/safe/../../.vimrc.local')
  source .vimrc.local
endif

if filereadable($HOME . '/.vimrc.local')
  source $HOME/.vimrc.local
endif

call s:EnsureNothingConflictsWithGrep()
