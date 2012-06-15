" "," is the <Leader> character
let mapleader=","

" Change the current working directory to the directory that the current file you are editing is in.
nnoremap <Leader>cd :cd %:p:h <CR>
" Opens a file with the current working directory already filled in so you have to specify only the filename.
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
nnoremap <Leader>v :vsplit <C-R>=expand("%:p:h") . '/'<CR>

nnoremap <Leader>rr :call Send_to_Tmux("r\n")<CR>

" Remove trailing whitespace
nnoremap <Leader>w :%s/\s\+$//e<CR>
" Directory explorer is 40 columns wide
nnoremap <Leader>n :40Vexplore<CR>

" Change mapping for ctrl-p plugin
let g:ctrlp_map = '<Leader>t'

" Stronger h
nnoremap H 0
" Stronger l
nnoremap L $

" Duplicate a selection
" Visual mode: D
vnoremap D y'>p

" Git
nnoremap <Leader>gc :Gcommit -m ""<LEFT>
nnoremap <Leader>gcv :Gcommit -v<CR>
nnoremap <Leader>ga :Git add .<CR>
" Show blame info for selected text (via Mike Burns)
vnoremap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

nnoremap <Leader>ctags :!ctags -f 'tmp/tags' -R --langmap="ruby:+.rake.builder.rjs" .<CR>

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
inoremap kj <Esc>:w<CR>
" Use apostrophe for backquote function, since backquote is so much more
" useful than apostrophe
nnoremap ` '

" Chapter 14 - autocmd groups
augroup filetype_html
  " Clear the augroup - otherwise you just keep adding to the same group!
  autocmd!
  autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
augroup END
