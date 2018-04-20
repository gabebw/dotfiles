function! ReplacePickWith(command)
  normal! mi
  execute '2,$' . a:command
  normal! `i
endfunction

nnoremap <silent> <leader>f :call ReplacePickWith('Fixup')<CR>
nnoremap <silent> <leader>s :call ReplacePickWith('Squash')<CR>
