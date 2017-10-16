" Haskell has 4-space tabs
setlocal shiftwidth=4

" Run hlint over the current file
nnoremap <silent> <leader>hl :SyntasticCheck hlint<CR>

setlocal formatprg=stylish-haskell
