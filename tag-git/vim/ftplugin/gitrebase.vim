function! Fixup()
  normal! mi
  silent! 2,$s/^pick/fixup/e
  normal! `i
endfunction

nnoremap <silent> <leader>s :call Fixup()<CR>
