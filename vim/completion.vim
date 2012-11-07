" Completion {{{
" :set wildmenu enables a menu at the bottom of the vim/gvim window.
set wildmenu
set wildmode=list:longest,list:full
" wildignore: stuff to ignore when tab completing
set wildignore+=*.zip,*.gz,*.bz,*.tar
set wildignore=*.pyc,*.pyo,*.o,*.obj,*~
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**,vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**,tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.avi,*.wmv,*.ogg,*.mp3,*.mov

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
