" Change the current working directory to the directory that the current file you are editing is in.
nnoremap <Leader>cd :cd %:p:h <CR>

" Opens a file with the current working directory already filled in so you have to specify only the filename.
nnoremap <Leader>e :e <C-R>=escape(expand("%:p:h"), ' ') . "/" <CR>
nnoremap <Leader>s :split <C-R>=escape(expand("%:p:h"), ' ') . "/" <CR>
nnoremap <Leader>v :vsplit <C-R>=escape(expand("%:p:h"), ' ') . "/" <CR>

" ReRun last command
nnoremap <Leader>rr :write\|VtrSendCommand! !-1 <CR>

" Directory explorer is 40 columns wide
nnoremap <Leader>n :40Vexplore<CR>

nnoremap <Leader>g :Ag<Space>

" Buffer navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h

" Disable K looking stuff up
nnoremap K <Nop>
" no ex mode
map Q <Nop>

" Typo
nnoremap :Nohl :nohlsearch
