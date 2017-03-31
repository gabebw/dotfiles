" Taken from https://github.com/derekprior/vim-trimmer

if !exists('g:trimmer_repeated_lines_blacklist')
  let g:trimmer_repeated_lines_blacklist = []
endif

augroup vimTrimmer
  autocmd!
  autocmd BufWritePre * call s:Trim(g:trimmer_repeated_lines_blacklist)
augroup END

function! s:Trim(blacklist)
  let l:pos = getpos('.')
  call s:TrimTrailingWhitespace()
  if index(a:blacklist, &filetype) < 0
    call s:TrimRepeatedBlankLines()
  endif
  call setpos('.', l:pos)
endfunction

function! s:TrimTrailingWhitespace()
  %s/\s\+$//e
endfunction

function! s:TrimRepeatedBlankLines()
  %s/\n\{3,}/\r\r/e
  %s#\($\n\s*\)\+\%$##e
endfunction
