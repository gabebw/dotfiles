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
  if match(expand('%'), '_spec\.rb$') != -1
    return "rspec --drb"
  elseif match(expand('%'), 'spec/acceptance/') != -1
    " Turnip
    return "rspec -r turnip --drb"
  elseif match(expand('%'), '\.feature$') != -1
    return "cucumber --drb"
  elseif match(expand('%'), '_test\.rb$') != -1
    " TestUnit
    return "ruby -Itest"
  else
    echoerr "Can't run test (is this a test file?)"
  endif
endfunction

function! RunCurrentTest()
  let command_string = "" . CorrectTestRunner() . " " . expand('%:p')
  call Send_to_Tmux(command_string . "\n")
endfunction

function! RunCurrentLineInTest()
  if CorrectTestRunner() == "ruby -Itest"
    " TestUnit can't do specific lines
    call RunCurrentTest()
  else
    let command_string = "" . CorrectTestRunner() . " " . expand('%:p') . ":" . line(".")
    call Send_to_Tmux(command_string . "\n")
  endif
endfunction
