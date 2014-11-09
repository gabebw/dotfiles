" Requires:
"   * rdio-cli gem (and thus OS X)
"   * Rdio desktop app
function! RdioNext()
  call system("rdio next")
endfunction

function! RdioPrevious()
  call system("rdio previous")
endfunction

nnoremap <Leader>rn :call RdioNext()<Enter>
nnoremap <Leader>rp :call RdioPrevious()<Enter>
