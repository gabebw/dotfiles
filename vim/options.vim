if version >= 703 " 703 = Vim 7.3
  set relativenumber " line numbers are relative to current line
  set undofile " Create FILE.un~ files for persistent undo
  " Persistent undo
  silent !mkdir ~/.vim/undodir > /dev/null 2>&1
  set undodir=~/.vim/undodir
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
set visualbell " No more beeping - supposedly flashes the screen instead, but doesn't happen for me
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.
set nojoinspaces " Don't insert a space when joining lines, e.g. with J
set noswapfile
" Don't add the comment prefix when I hit enter or o/O on a comment line. Must
" be removed one-by-one.
set formatoptions-=o
set formatoptions-=r
" Tell vim to remember certain things when we exit
"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :20 : up to 20 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
" From https://gist.github.com/955547
set viminfo='10,\"100,:20,%,n~/.viminfo

" Open below and to the right, the same way you read a page
set splitbelow splitright

set cursorline
" Always display statusline
set laststatus=2

set fileencodings=utf-8,iso-8859-1
set fileformats=unix,mac,dos
set textwidth=80
set showbreak="@" " This is prepended to wrapped lines
" Display extra whitespace
set list listchars=tab:»·,trail:·

" `yy` copies to clipboard, so you don't have to do `"*yy`. Bad. Ass.
set clipboard=unnamed
