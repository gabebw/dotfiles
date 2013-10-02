if !exists("g:trimmer_blacklist")
  let g:trimmer_blacklist = []
endif

augroup vimTrimmer
  autocmd!
  autocmd BufWritePre * call s:TrimTrailingWhitespace(g:trimmer_blacklist)
augroup END

function! s:TrimTrailingWhitespace(blacklist)
  if index(a:blacklist, &ft) < 0
    let l:pos = getpos(".")
    %s/\s\+$//e
    call setpos(".", l:pos)
  endif
endfunction
