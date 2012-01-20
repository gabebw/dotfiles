" Custom, non-autocommand functions

function! NoDistractions()
  " cursor doesn't blink
  set guicursor=a:blinkon0
  " Remove scrollbar in gvim
  set guioptions-=r
  " Remove menubar
  set guioptions-=T
  " fullscreen. duh.
  set fullscreen
endfunction

nnoremap <Leader>a :call RunCurrentTest()<CR>
nnoremap <Leader>l :call RunCurrentLineInTest()<CR>

function! CorrectTestRunner()
  if match(expand('%'), '\.feature$') != -1
    return "cucumber --drb"
  elseif match(expand('%'), '_spec\.rb$') != -1
    return "rspec --drb"
  endif
endfunction

function! RunCurrentTest()
  exec "!" . CorrectTestRunner() . " " . expand('%:p')
endfunction

function! RunCurrentLineInTest()
  exec "!" . CorrectTestRunner() . " " . expand('%:p') . ":" . line(".")
endfunction
