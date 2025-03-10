" vim: foldmethod=marker foldlevel=1
" The folding settings above make the {{{ and }}} sections fold up.

" Disable Vi compatibility.
set nocompatible

" Ensure we use a more POSIX-compatible shell than Fish for Vim stuff like :%!
if &shell =~# 'fish$'
  set shell=zsh
endif

" Leader is <Space>. Set it early because leader is used at the moment mappings
" are defined. Changing mapleader after a mapping is defined has no effect on
" the mapping.
let mapleader=' '

" ============================================================================
" AUTOCOMMANDS {{{
" ===========================================================================
" Without this, the next line copies a bunch of netrw settings like `let
" g:netrw_dirhistmax` to the system clipboard.
" I never use netrw, so disable its history.
let g:netrw_dirhistmax = 0

augroup vimrc
  " Clear all autocommands in this group so that I don't need to do `autocmd!`
  " for each command. This just clears all of them at once.
  autocmd!

  " on opening the file, clear search-highlighting
  autocmd BufReadCmd set nohlsearch

  " Highlight the current line, only for the buffer with focus
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

  " Include ! as a word character, so dw will delete all of e.g. gsub!,
  " and not leave the "!"
  autocmd FileType ruby,eruby,yaml set iskeyword+=!,?
  " Highlight text between two "---"s as a comment.
  " `\_x` means "x regex character class, with newlines allowed"
  autocmd BufNewFile,BufRead,BufWrite *.md,*.markdown,*.html syntax match Comment /\%^---\_.\{-}---$/
  autocmd VimResized * wincmd =

  " Re-source vimrc whenever it changes
  autocmd BufWritePost vimrc,$MYVIMRC,.vimrc.bundles.local nested if expand("%") !~ 'fugitive' | source % | endif

  " Don't let netrw override <C-l> to move between tmux panes
  " https://github.com/christoomey/vim-tmux-navigator/issues/189
  autocmd filetype netrw call NetrwMapping()
augroup END

" vim-rails + vim-projectionist
augroup rails_shortcuts
  autocmd!
  autocmd User Rails nnoremap <Leader>m :Emodel<Space>
  autocmd User Rails nnoremap <Leader>c :Econtroller<Space>
  autocmd User Rails nnoremap <Leader>v :Eview<Space>
  autocmd User Rails nnoremap <Leader>u :Eunittest<Space>
augroup END

augroup Javascript
  " https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim#highlighting-for-large-files
  " Keep highlighting in sync (at a performance cost)
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
  autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
augroup END

augroup json
  autocmd!
  " indent json files on save
  autocmd FileType json autocmd BufWritePre <buffer> let b:json_old_pos = getpos(".") | execute "%!jq ." | call setpos('.', b:json_old_pos) | unlet b:json_old_pos
augroup END

augroup verymagic
  " Pretend that verymagic is always on
  nnoremap / /\v
  cnoremap %s/ %s/\v
augroup END

function! NetrwMapping()
  nnoremap <silent> <buffer> <c-l> :TmuxNavigateRight<CR>
endfunction
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
nnoremap <Leader>e :e <C-R>=escape(expand('%:p:h'), ' ') . '/' <CR>

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
command! -nargs=+ -complete=file -bar Grep silent! grep! -F <q-args> | copen 10 | redraw!
command! -nargs=+ -complete=file -bar GrepRegex silent! grep! <args> | copen 10 | redraw!

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
    execute 'GrepRegex ''\b' . shellescape(searchable_word) . '\b'''
  end
endfunction

nnoremap K :call SearchForWordUnderCursor()<CR>

" Close all other windows in this tab, and don't error if this is the only one
nnoremap <Leader>o :silent only<CR>

" Movement
" move vertically by _visual_ line
nnoremap j gj
nnoremap k gk

" no ex mode
map Q <Nop>

function! MyPaste()
  set paste
  let buffer = @+
  silent exe "normal! o" . buffer
  set nopaste
endfunction

augroup Pasting
  autocmd!
  autocmd VimEnter * silent! nunmap cv
  autocmd VimEnter * nnoremap cv :call MyPaste()<CR>
augroup END

" edit vimrc or shell config and load vimrc bindings
function! MaybeTabedit(file)
  let real_file = resolve(a:file)
  let new_empty_file = line('$') == 1 && getline(1) == '' && bufname('%') == ''
  if bufname('%') ==# real_file
    " Already editing this file, do nothing
  elseif new_empty_file
    " If this is an empty file, just replace it with the file to edit
    execute 'edit ' . real_file
  else
    execute 'tabedit ' . real_file
  endif
endfunction
nnoremap <leader>ev :call MaybeTabedit($MYVIMRC)<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>q :call MaybeTabedit('$HOME/.config/fish/config.fish')<CR>

" Typo
nnoremap :Nohl :nohlsearch

" Automatically reselect text after in- or out-denting in visual mode
xnoremap < <gv
xnoremap > >gv

" ReRun last command
nnoremap <Leader>rr :write\|VtrSendCommand! eval $history[1]<CR>
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
set modelines=2   " inspect top/bottom 2 lines of the file for a modeline
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
set ttimeout " Default is to never time out
set ttimeoutlen=100 " default is 1 second, which is a long time

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

set grepprg=rg\ --hidden\ --vimgrep\ --with-filename\ --max-columns\ 200\ --smart-case
set grepformat=%f:%l:%c:%m
" }}}

" ============================================================================
" PLUGIN OPTIONS {{{
" ===========================================================================

" Supertab
" Tell Supertab to start completions at the top of the list, not the bottom.
let g:SuperTabDefaultCompletionType = "<c-n>"

" gundo
" -----
" Without this, Gundo won't run because Python 2 isn't installed.
let g:gundo_prefer_python3 = 1

" peekaboo
" --------
let g:peekaboo_window	= 'vert bo 50new'

" FZF
" -----------------
" This prefixes all FZF-provided commands with 'Fzf' so I can easily find cool
" FZF commands and not have to remember 'Colors' and 'History/' etc.
let g:fzf_command_prefix = 'Fzf'
" Ctrl-M is Enter: open in tabs by default
let g:fzf_action = {
  \ 'ctrl-m': 'tabedit',
  \ 'ctrl-o': 'edit',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

command! -bang -nargs=? -complete=dir FilesWithPreview
     \ call fzf#vim#files(<q-args>,
     \   fzf#vim#with_preview(),
     \   <bang>0)

nnoremap <Leader>t :FilesWithPreview<CR>

" easytags
" ----------
let g:easytags_async = 1
let g:easytags_cmd = '/usr/local/bin/ctags'

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

" fugitive
" --------
" Get a direct link to the current line (with specific commit included!) and
" copy it to the system clipboard
command! GitLink silent .Gbrowse!
command! GitLinkFile silent 0Gbrowse!

augroup Fugitive
  autocmd!
  " Open the commit hash under the cursor, in GitHub
  autocmd FileType fugitiveblame nnoremap <buffer> <silent> gb :Gbrowse <C-r><C-w><CR>
augroup END
" Prevent Fugitive from raising an error about .git/tags by telling it to
" explicitly check .git/tags
set tags^=./.git/tags

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
" Zoom into tmux test runner pane. To get back to vim, use <C-a><C-u>
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

" JSX
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

command! LightlineReload call LightlineReload()
function! LightlineReload()
  " Don't run this if Lightline hasn't been installed yet
  if exists('*lightline#init')
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  endif
endfunction

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
let g:lightline.active.right = [
      \ [ 'filetype'],
      \ ]
let g:lightline.component.readonly = '%{(&filetype!="help" && &readonly) ? "RO" : ""}'
let g:lightline.component_function.fugitive = 'LightLineGitBranch'
let g:lightline.component_function.myfilename = 'LightLineFilename'
let g:lightline.component_visible_condition.readonly = '(&filetype!="help"&& &readonly)'
let g:lightline.component_visible_condition.fugitive = '(exists("*fugitive#head") && ""!=fugitive#head())'
let g:lightline.tabline.right = [] " Disable the 'X' on the far right

function! LightLineGitBranch()
  let l:max = 25
  if exists("*fugitive#head") && "" != fugitive#head()
    let branch = fugitive#head()
    if len(branch) > l:max
      " Long branch names get truncated
      return branch[0:l:max-3] . '...'
    else
      return branch
    endif
  else
    return ""
  endif
endfunction

function! LightLineFilename()
  let unfollowed_symlink_filename = expand('%:p')
  let filename = resolve(unfollowed_symlink_filename)
  let git_root = fnamemodify(FugitiveExtractGitDir(filename), ':h')

  if expand('%:t') == ''
    return '[No Name]'
  elseif git_root != '' && git_root != '.'
    let path = substitute(filename, git_root . '/', '', '')
    " Check if the git root is in another directory, like a dotfile in ~/.vimrc
    " that's really in ~/code/personal/dotfiles/vimrc
    if FugitivePath(filename) !=# unfollowed_symlink_filename
      return path . ' @ ' . git_root
    else
      return path
    endif
  else
    return filename
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
command! Gpr :Git create-pull-request
command! -nargs=1 Gbranch :Git checkout -b
" }}}

" ============================================================================
" PLUGINS {{{
" ===========================================================================
" vim-plug: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/bundle')

" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Ruby/Rails
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
" Allow `cir` to change inside ruby block, etc
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-projectionist'
Plug 'janko-m/vim-test'
Plug 'dag/vim-fish'

" tmux
Plug 'christoomey/vim-tmux-runner'
Plug 'christoomey/vim-tmux-navigator'

" Syntax
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/applescript.vim'
Plug 'shmup/vim-sql-syntax'
Plug 'tpope/vim-git'
Plug 'cespare/vim-toml'

" Plumbing that makes everything nicer
" Fuzzy-finder
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
" Easily comment/uncomment lines in many languages
Plug 'tomtom/tcomment_vim'
" <Tab> indents or triggers autocomplete, smartly
Plug 'ervandew/supertab'
" Git bindings
Plug 'tpope/vim-fugitive'
" The Hub to vim-fugitive's git
Plug 'tpope/vim-rhubarb'
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
Plug 'xim/file-line'
Plug 'christoomey/vim-sort-motion'
Plug 'flazz/vim-colorschemes'
Plug 'sjl/gundo.vim'
Plug 'xolox/vim-misc' | Plug 'xolox/vim-easytags'
" Easily inspect registers exactly when you need them
" https://github.com/junegunn/vim-peekaboo
Plug 'junegunn/vim-peekaboo'

" Text objects
" required for all the vim-textobj-* plugins
Plug 'kana/vim-textobj-user'
" `ae` text object, so `gcae` comments whole file
Plug 'kana/vim-textobj-entire'
" `l` text object for the current line excluding leading whitespace
Plug 'kana/vim-textobj-line'

" Markdown
Plug 'tpope/vim-markdown'
Plug 'nicholaides/words-to-avoid.vim', { 'for': 'markdown' }
" It does more, but I'm mainly using this because it gives me markdown-aware
" `gx` so that `gx` works on [Markdown](links).
Plug 'christoomey/vim-quicklink', { 'for': 'markdown' }
" Make `gx` work on 'gabebw/dotfiles' too
Plug 'gabebw/vim-github-link-opener', { 'branch': 'main' }

" LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    " nmap <buffer> gs <plug>(lsp-document-symbol-search)
    " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    " nmap <buffer> gr <plug>(lsp-references)
    " nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    " nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    " nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()

    if executable('standardrb')
      " Get feedback from standardrb
      au User lsp_setup call lsp#register_server({
            \ 'name': 'standardrb',
            \ 'cmd': ['standardrb', '--lsp'],
            \ 'allowlist': ['ruby'],
            \ })
      " Autoformat ruby files on save with standardrb
      autocmd FileType ruby autocmd BufWritePre <buffer> LspDocumentFormat
    endif
augroup END

" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')

if executable('standardrb')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'standardrb',
        \ 'cmd': ['standardrb', '--lsp'],
        \ 'allowlist': ['ruby'],
        \ })
endif

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

  hi SpellBad cterm=underline ctermfg=red
  " Highlight ruby TODO etc in red
  hi rubyTodo cterm=underline ctermfg=red
  " Make some things italic
  hi! Comment term=italic cterm=italic gui=italic
  hi! Constant term=italic cterm=italic gui=italic
  hi! link gitCommitComment Comment
  hi! link gitCommitHeader Comment
  " Ensure that Rust special comments (like doc comments) are highlighted as
  " comments
  hi! link rustCommentLineDoc Comment
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

" This means we can edit the Vimrc and have lightline pick up the changes every
" time
LightlineReload
call s:EnsureNothingConflictsWithGrep()
