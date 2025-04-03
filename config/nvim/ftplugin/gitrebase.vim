function! s:ReplacePickWith(command)
  normal! mi
  execute '2,$' . a:command
  normal! `i
endfunction

nnoremap <silent> <buffer> <leader>f :call <SID>ReplacePickWith('Fixup')<CR>
nnoremap <silent> <buffer> <leader>s :call <SID>ReplacePickWith('Squash')<CR>
