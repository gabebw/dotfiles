function! ReplacePickWith(command)
  normal! mi
  execute 'silent! 2,$s/^[^# ]\+/' . a:command . '/e'
  normal! `i
endfunction

nnoremap <silent> <leader>f :call ReplacePickWith('fixup')<CR>
nnoremap <silent> <leader>s :call ReplacePickWith('squash')<CR>
