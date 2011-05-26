" Good .vimrc files
" http://people.mandriva.com/~rgarciasuarez/dotfiles/vimrc
" To see value of a variable inside vim, do (e.g.) "echo version"
set nocompatible

filetype off " per http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html

" Wow, this cleaned up my ~/.vim like you would not believe.
" http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen
" Note that pathogen must be called before built-in filetype plugin is
" loaded
call pathogen#infect()
call pathogen#helptags() " Generate help tags for every bundle

" RVM fix via http://rvm.beginrescueend.com/integration/vim/
set shell=/bin/sh

" Vundle; see https://github.com/gmarik/vundle
" To install, run :BundleInstall
" To update, run BundleInstall!
" **DO NOT** put a call to BundleInstall in your vimrc! It'll recurse A LOT
" and things will get weird.
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles:
" let Vundle manage Vundle
Bundle 'gmarik/vundle'
Bundle 'jquery'
Bundle 'css'
Bundle 'pydoc'
" Bundle 'pyflakes'
Bundle 'scrooloose/nerdtree'
Bundle 'tsaleh/vim-matchit'

" tab completion
Bundle 'ervandew/supertab'

" Syntax and the like
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rails'
Bundle 'tsaleh/vim-shoulda'
Bundle 'vim-ruby/vim-ruby'
Bundle 'godlygeek/tabular'

" Colorschemes
Bundle 'Railscasts-Theme-GUIand256color'
Bundle 'vividchalk.vim'
Bundle 'molokai'

" Turn on syntax highlighting when we have colors or gui is running
if &t_Co > 2 || has("gui_running") " &t_Co > 2 => we have colors
  syntax on
endif

" http://vim.runpaint.org/display/changing-status-line/
" http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
" Status line detail:
" %F = file name ("~/.vimrc")
" %t = file BASENAME (".vimrc")
" strftime.... = time
"   (See: http://vim.wikia.com/wiki/Insert_current_date_or_time)
" getftime = last modification time
" %P = ??? something with percentage ???
set laststatus=2 " always display status line
" clear statusline
set statusline=
set statusline+=%{fugitive#statusline()}
" %2* means invert the background/foreground colors
set statusline+=%2*
" space at the end
" Add empty quotes at end so that removing trailing whitespace won't remove
" that space
set statusline+=\ ""

" buffer number
set statusline+=%2*buf:\ %-3.3n%0*
" %f = Path to the file in the buffer, as typed or relative to current
" directory. %t = file basename
set statusline+=%f
" FLAGS
" %m = display "[+]" if file has been modified
" %r = display "[RO]" if file is read-only
" %h = help buffer flag, "[help]"
" %w = [Preview] if in preview window
" %y = file content type, e.g. "[ruby]" - includes brackets
" %{&ff} = file format (unix/dos)
set statusline+=%m%r%h%w%y\ fmt=%{&ff} " flags
set statusline+=\  " add a space
" %l = current line number
" %L = total lines
" %c = current column
set statusline+=lin\:%l/%L\ col\:%c " line and column
" %= = right-align everything after this
set statusline+=%= " right align
" last modified time, like "07/29/10 07:36:44"
set statusline+=%{strftime(\"%m/%d/%y\ %T\",getftime(expand(\"%:p\")))}

if has("gui_running")
  colorscheme railscasts
  "colorscheme mustang

  " FONTS
  if has('win32')
    set gfn=Bitstream\ Vera\ Sans\ Mono\ 12 " Use the Bitstream font
  else
    if has('gui_gtk2') " GTK2 but not GTK1
      try
        set guifont=Inconsolata\ 15
      catch /E596:/ " Invalid font
        set guifont=Menlo\ 12
      endtry
    elseif has('gui_macvim') " MacVim
      try
        set guifont=Inconsolata:h15
      catch /E596:/ " Invalid font
        set guifont=Menlo:h12 " Use the Menlo font
      endtry
    endif
  endif
else
  "colorscheme molokai
endif


if version >= 703 " 703 = Vim 7.3
  "set relativenumber " line numbers are relative to current line
  set undofile " Create FILE.un~ files for persistent undo
  " Persistent undo
  if has('win32')
    set undodir=C:\Windows\Temp
  else
    set undodir=~/.vim/undodir
  endif
endif
set number " non-relative line numbers
set numberwidth=3 " minimum
set ruler  " show cursor position all the time
set nowrap " don't wrap lines
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent
set copyindent " copy previous indentation on autoindenting
set showmatch " show matching parenthesis
set ignorecase " ignore case when searching
set smartcase " ignore case if search pattern is all lowercase, case-sensitive otherwise
set smarttab " insert tabs on the start of a line according to shiftwidth, not tabstop
set incsearch " show search matches as you type
set showcmd " display incomplete commands
set modelines=2 " inspect top/bottom 2 lines for modeline
set scrolloff=3 " When scrolling, show 3 lines of context

set fileencodings=utf-8,iso-8859-1
set fileformats=unix,mac,dos
set textwidth=78
set showbreak="@" " This is prepended to wrapped lines
" Display extra whitespace
set list listchars=tab:»·,trail:·

" **** TABS ****
" Note that ~/.vim/after/ftplugin changes some of these settings
" http://vim.wikia.com/wiki/Indenting_source_code#Setup
" No tabs: set expandtab, set shiftwidth=softtabstop, don't change tabstop
" Pure tabs: set noexpandtab, set tabstop=shiftwidth, don't touch softtabstop
" Tabs+spaces: set noexpandtab, set softtabstop=shiftwidth, don't touch tabstop
"
" http://vim.wikia.com/wiki/Indenting_source_code#Explanation_of_the_options
" tabstop = how many columns a TAB counts for
" shiftwidth = what happens when you press <</>>/==
" softtabstop = number of spaces inserted when TAB is pressed
" expandtab = if expandtab is set, then <TAB> inserts softtabstop amount of
" space characters. Otherwise, the amount of spaces inserted is minimized by
" using TAB characters
" Currently ruby style (tabs = 2 spaces)
set expandtab
" set tabstop=4
set softtabstop=2
set shiftwidth=2

" With backup and writebackup on, it overwrites the old backup
set backup
set writebackup
set backupdir=~/.vim/backups
" setting backupskip to this to allow for 'crontab -e' using vim.
" thanks to: http://tim.theenchanter.com/2008/07/crontab-temp-file-must-be-edited-in.html
if has('unix')
  set backupskip=/tmp/*,/private/tmp/*"
endif

" views options
set viewdir=~/.vim/views
" http://github.com/tpope/vim-rails/issues/closed/#issue/25
" Having these mkview lines make rails.vim not work (lots of "File not in
" path" errors.
" Match all files but don't trigger when opening vim without a file
"autocmd BufWinLeave ?* mkview
"autocmd BufWinEnter ?* silent loadview

" map autocomplete to Tab
imap <Tab> <C-P>
" whack kj to escape
inoremap kj <esc>


" "," is the <Leader> character
let mapleader=","

" Change the current working directory to the directory that the current file you are editing is in.
map <Leader>cd :cd %:p:h <CR>
" Opens a file with the current working directory already filled in so you have to specify only the filename.
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
" Remove trailing whitespace before saving
map <Leader>w :%s/\s\+$//e<CR>
" Run scheme
"map <Leader>r :!mit-scheme --edit --load "<C-R>=expand("%:p:h") . "/" <CR>"
map <Leader>n :NERDTreeToggle<CR>

augroup rails_shortcuts
  " Rails.vim
  " Leader shortcuts for Rails commands
  " from http://github.com/ryanb/dotfiles/blob/master/vimrc
  " Rails configuration - from jferris
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

  " Steps
  autocmd User Rails map <Leader>p :Rstep
  autocmd User Rails map <Leader>tp :RTstep
  autocmd User Rails map <Leader>sp :RSstep

  " Models
  autocmd User Rails map <Leader>m :Rmodel
  autocmd User Rails map <Leader>tm :RTmodel
  autocmd User Rails map <Leader>sm :RSmodel

  " Controller
  autocmd User Rails map <Leader>c :Rcontroller
  autocmd User Rails map <Leader>tc :RTcontroller
  autocmd User Rails map <Leader>sc :RScontroller

  " Views
  autocmd User Rails map <Leader>v :Rview
  autocmd User Rails map <Leader>tv :RTview
  autocmd User Rails map <Leader>sv :RSview

  " Test
  autocmd User Rails map <Leader>u :Runittest
  autocmd User Rails map <Leader>tu :RTunittest
  autocmd User Rails map <Leader>su :RSunittest

  autocmd User Rails map <Leader>h :Rhelper
  autocmd User Rails map <Leader>i :Rintegrationtest

  autocmd User Rails map <Leader>f :Rfunctionaltest
  autocmd User Rails map <Leader>tf :RTfunctionaltest
  autocmd User Rails map <Leader>sf :RSfunctionaltest

  autocmd User Rails map <Leader>i :Rintegrationtest
  autocmd User Rails map <Leader>ti :RTintegrationtest
  autocmd User Rails map <Leader>si :RSintegrationtest

  autocmd User Rails map <Leader>g :Rconfig
  autocmd User Rails map <Leader>tg :RTconfig
  autocmd User Rails map <Leader>sg :RSconfig

  command! Rroutes :e config/routes.rb
  " When you call Rpreview <x>, use this command to open localhost:3000/<x>
  command! -bar -nargs=1 OpenURL :!open <args>
augroup END

" Move lines up and down
"map <C-J> :m +1 <CR>
"map <C-K> :m -2 <CR>
" Window navigation
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>
nmap <C-H> <C-W><C-H>

" Mappings
map :Nohl :nohlsearch
" no ex mode
map Q q
inoremap kj <Esc>
" Use apostrophe for backquote function, since backquote is so much more
" useful than apostrophe
nnoremap ` '

" Completion {{{
" :set wildmenu enables a menu at the bottom of the vim/gvim window.
set wildmenu
" list:longest    - When > 1 match, list all matches and
"                   complete till longest common string.
" full            - enables you to tab through the remaining completions
set wildmode=list:longest,full
set wildignore+=*.pyc,*.zip,*.gz,*.bz,*.tar,*.jpg,*.png,*.gif,*.avi,*.wmv,*.ogg,*.mp3,*.mov
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
" end completion }}}

" Allows % to switch between if/elsif/else/end, open/close XML tags, and
" more.
runtime macros/matchit.vim

" Auto commands {{{
if has("autocmd")
  " Turn on filetype detection, filetype plugins, and per-filetype indenting
  filetype plugin indent on
  " on opening the file, clear search-highlighting
  autocmd BufReadCmd set nohlsearch

  " Highlight trailing whitespace except on the current line
  autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
  autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
  highlight EOLWS ctermbg=red guibg=red

  " http://github.com/technicalpickles/pickled-vim/blob/master/home/.vimrc
  augroup myfiletypes
    " Clear old autocmds in group
    autocmd!
    " autoindent with two spaces, always expand tabs
    autocmd FileType ruby,eruby,yaml set autoindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab
    " Include ! as a word character, so dw will delete all of e.g. gsub!,
    " and not leave the "!"
    autocmd FileType ruby set iskeyword+=!
    autocmd FileType javascript set autoindent shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType vim set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType cucumber set autoindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    " Magic Python settings
    autocmd FileType python source ~/.vim/python

    " treat rackup files like ruby
    au BufRead,BufNewFile *.ru set ft=ruby
    au BufRead,BufNewFile Gemfile set ft=ruby
    au BufRead,BufNewFile .autotest set ft=ruby

    " .gitconfig and gitconfig are the same
    au BufRead,BufNewFile gitconfig set syntax=gitconfig

    autocmd BufRead ~/.dotfiles/extra/* set syntax=zsh ft=zsh
    autocmd BufRead ~/.dotfiles/zsh/* set syntax=zsh ft=zsh
    autocmd BufRead /usr/share/file/magic/* set syntax=magic
    autocmd BufRead /Users/gabe/Projects/thinkingtank/lib/*.rb set autoindent shiftwidth=4 softtabstop=4 tabstop=4 expandtab
    autocmd BufRead /Users/gabe/Projects/thinkingtank/lib/thinkingtank/*.rb set autoindent shiftwidth=4 softtabstop=4 tabstop=4 expandtab
  augroup END " END myfiletypes

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event
  " handler (happens when dropping a file on gvim).
  " via: http://github.com/jferris/config_files/blob/master/vimrc
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
endif " Auto commands }}}
