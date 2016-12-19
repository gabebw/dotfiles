" Change the current working directory to the directory that the current file you are editing is in.
nnoremap <Leader>cd :cd %:p:h <CR>

" Opens a file with the current working directory already filled in so you have to specify only the filename.
nnoremap <Leader>e :e <C-R>=escape(expand("%:p:h"), ' ') . "/" <CR>
nnoremap <Leader>s :split <C-R>=escape(expand("%:p:h"), ' ') . "/" <CR>
nnoremap <Leader>v :vsplit <C-R>=escape(expand("%:p:h"), ' ') . "/" <CR>

" Mnemonic: vgf = "vsplit gf"
nnoremap vgf :vsplit<CR>gf<CR>

" Only have the current split and tab open
nnoremap <Leader>o :silent only\|silent tabonly<CR>

" Buffer navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h

" no ex mode
map Q <Nop>

" re-select the last pasted text
nnoremap gV V`]

" Typo
nnoremap :Nohl :nohlsearch

" Automatically reselect text after in- or out-denting in visual mode
xnoremap < <gv
xnoremap > >gv

" Act like D and C
nnoremap Y y$
