" Change the current working directory to the directory that the current file you are editing is in.
nnoremap <Leader>cd :cd %:p:h <CR>
" Opens a file with the current working directory already filled in so you have to specify only the filename.
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
nnoremap <Leader>v :vsplit <C-R>=expand("%:p:h") . '/'<CR>
nnoremap <Leader>rr :call Send_to_Tmux("clear\n!-2\n")<CR>

" Remove trailing whitespace
nnoremap <Leader>w :%s/\s\+$//e<CR>
" Directory explorer is 40 columns wide
nnoremap <Leader>n :40Vexplore<CR>

" Change mapping for ctrl-p plugin
let g:ctrlp_map = '<Leader>t'

" Buffer navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Disable K looking stuff up
nnoremap K <Nop>
nnoremap :Nohl :nohlsearch
" no ex mode
map Q <Nop>
