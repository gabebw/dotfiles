" Haskell has 4-space tabs
set shiftwidth=4

" All of the stuff below is from
" https://github.com/begriffs/haskell-vim-now/blob/705a57b9f968f374e92e884e38b076cc6a7bbf2f/.vimrc

" Run hlint over the current file
nnoremap <silent> <leader>hl :SyntasticCheck hlint<CR>

" Hoogle the word under the cursor
nnoremap <silent> <leader>hh :Hoogle<CR>

" Hoogle for the word under the cursor and display a list of results to choose
" from
nnoremap <leader>hH :Hoogle

" Hoogle for the word under the cursor and display the first result
nnoremap <silent> <leader>hi :HoogleInfo<CR>

" Hoogle, but you type what to search for
nnoremap <leader>hI :HoogleInfo<Space>

" Hoogle, close the Hoogle window
nnoremap <silent> <leader>hz :HoogleClose<CR>
