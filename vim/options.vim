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
set visualbell " No more beeping - supposedly flashes the screen instead, but doesn't happen for me
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.
" Use _ as a word-separator
set iskeyword+=?

set fileencodings=utf-8,iso-8859-1
set fileformats=unix,mac,dos
set textwidth=78
set showbreak="@" " This is prepended to wrapped lines
" Display extra whitespace
set list listchars=tab:»·,trail:·
set guioptions-=T " Don't show the menubar
