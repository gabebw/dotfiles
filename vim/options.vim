set history=50
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set ruler         " show cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set cursorline    " highlight the line the cursor is on
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set modelines=2   " inspect top/bottom 2 lines for modeline
set scrolloff=3   " When scrolling, show 3 lines of context
set shiftround    " When at 3 spaces and I hit >>, go to 4, not 5.

" Copy to the system clipboard
set clipboard=unnamed

" Persistent undo
set undofile " Create FILE.un~ files for persistent undo
silent !mkdir ~/.vim/undodir > /dev/null 2>&1
set undodir=~/.vim/undodir

" Numbers
set relativenumber
set numberwidth=3

set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent
set copyindent " copy previous indentation on autoindenting
set showmatch " show matching parenthesis

" Searching
set ignorecase " ignore case when searching
set smartcase  " ignore case if search pattern is all lowercase, case-sensitive otherwise


" Open below and to the right, the same way you read a page
set splitbelow splitright

" File encoding and format
set fileencodings=utf-8,iso-8859-1
set fileformats=unix,mac,dos
set textwidth=80

" Meta characters
" Prepended to wrapped lines
set showbreak="@"
" Display extra whitespace
set list listchars=tab:»·,trail:·

