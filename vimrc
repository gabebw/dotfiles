" Good .vimrc files
" http://people.mandriva.com/~rgarciasuarez/dotfiles/vimrc
" To see value of a variable inside vim, do (e.g.) "echo version"
set nocompatible

" Wow, this cleaned up my ~/.vim like you would not believe.
" http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen
" Note that pathogen must be called before built-in filetype plugin is
" loaded
filetype off " per http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
call pathogen#runtime_append_all_bundles()
call pathogen#helptags() " Generate help tags for every bundle

" Turn on syntax highlighting when we have colors or gui is running
if &t_Co > 2 || has("gui_running") " &t_Co > 2 => we have colors
  syntax on
endif

" http://vim.runpaint.org/display/changing-status-line/
" http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
" Status line detail:
" %F = file name ("~/.vimrc")
" %t = file BASENAME (".vimrc")
" %{&ff} = file format (unix/dos)
" strftime.... = time
"   (See: http://vim.wikia.com/wiki/Insert_current_date_or_time)
" getftime = last modification time
" %= = right-align everything after this
" %l = current line number
" %L = total lines
" %c = current column
" %P = ??? something with percentage ???
set laststatus=2 " always display status line
" clear statusline
set statusline=
if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif
set statusline+=%2*buf:\ %-3.3n%0* " buffer number
" %f = Path to the file in the buffer, as typed or relative to current
" directory. %t = file basename
set statusline+=%f
" FLAGS
" %m = display "[+]" if file has been modified
" %r = display "[RO]" if file is read-only
" %h = help buffer flag, "[help]"
" %w = [Preview] if in preview window
" %y = file content type, e.g. "[ruby]" - includes brackets
set statusline+=%m%r%h%w%y " flags
set statusline+=\  " add a space
set statusline+=lin\:%l/%L\ col\:%c " line and column
set statusline+=%= " right align
" last modified time, like "07/29/10 07:36:44"
set statusline+=%{strftime(\"%m/%d/%y\ %T\",getftime(expand(\"%:p\")))}

if has("gui_running")
  colorscheme railscasts
  "colorscheme mustang
else
  "colorscheme molokai
endif

"set gfn=Bitsteam\ Vera\ Sans\ Mono\ 12 " Use the Bitstream font
set gfn=Menlo\ 12 " Use the Menlo font

if version >= 703 " 703 = Vim 7.3
  set relativenumber " line numbers are relative to current line
  set undofile " Create FILE.un~ files for persistent undo
else
  set number " non-relative line numbers
endif
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
set textwidth=76 " Numbers on the side take off 4 columns, 80-4 = 76
set showbreak="@" " This is prepended to wrapped lines
" tabs are trail, end of lines are $
set listchars=tab:>-,eol:$

" Use apostrophe for backquote function, since backquote is so much more
" useful than apostrophe
nnoremap ` '

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
set backupskip=/tmp/*,/private/tmp/*"

" views options
set viewdir=~/.vim/views
" http://github.com/tpope/vim-rails/issues/closed/#issue/25
" Having these mkview lines make rails.vim not work (lots of "File not in
" path" errors.
" Match all files but don't trigger when opening vim without a file
"autocmd BufWinLeave ?* mkview
"autocmd BufWinEnter ?* silent loadview

" map autocomplete to Tab
"imap <Tab> <C-N>

" "," is the <Leader> character
let mapleader=","

" Change the current working directory to the directory that the current file you are editing is in.
map <Leader>cd :cd %:p:h <CR>
" Opens a file with the current working directory already filled in so you have to specify only the filename.
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
" Remove trailing whitespace before saving
map <Leader>w :%s/\s\+$//e<CR>
" Run scheme
map <Leader>r :!mit-scheme --edit --load "<C-R>=expand("%:p:h") . "/" <CR>"

if exists('g:autoloaded_rails') && exists("b:rails_root")
  " Rails.vim
  " Leader shortcuts for Rails commands
  " from http://github.com/ryanb/dotfiles/blob/master/vimrc
  map <Leader>m :Rmodel
  map <Leader>c :Rcontroller
  map <Leader>v :Rview
  map <Leader>h :Rhelper
  map <Leader>u :Runittest
  map <Leader>f :Rfunctionaltest
  map <Leader>tm :RTmodel
  map <Leader>tc :RTcontroller
  map <Leader>tv :RTview
  map <Leader>tu :RTunittest
  map <Leader>tf :RTfunctionaltest
  map <Leader>sm :RSmodel
  map <Leader>sc :RScontroller
  map <Leader>sv :RSview
  map <Leader>su :RSunittest
  map <Leader>sf :RSfunctionaltest
  command! Rroutes :e config/routes.rb
endif

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

" When you call Rpreview <x>, use this command to open localhost:3000/<x>
command -bar -nargs=1 OpenURL :!open <args>

" Completion {{{
" "set wildmenu" enables a menu at the bottom of the vim/gvim window.
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

" Auto commands {{{
if has("autocmd")
  " Turn on filetype detection, filetype plugins, and per-filetype indenting
  filetype plugin indent on
  " FINALLY! Don't need to reload to detect syntax of a file with a valid
  " extension
  runtime! ftdetect/*.vim
  " on opening the file, clear search-highlighting
  autocmd BufReadCmd :set nohlsearch

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
    " treat rackup files like ruby
    au BufRead,BufNewFile *.ru set ft=ruby
    au BufRead,BufNewFile Gemfile set ft=ruby
    au BufRead,BufNewFile .autotest set ft=ruby

    autocmd BufRead ~/.dotfiles/extra/* set syntax=zsh
    autocmd BufRead ~/.dotfiles/zsh/* set syntax=zsh
    autocmd BufRead /usr/share/file/magic/* set syntax=magic
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

