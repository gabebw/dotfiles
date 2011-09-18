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

function! ConvertToMocha()
  exec "%s/should_receive/expects/ge"
  exec "%s/and_return/returns/ge"
  exec "%s/should_not_receive(\\([^)]*\\))/expects(\\1).never/ge"
  exec "%s/with(\\(\\/[^)]*\\))/with(regexp_matches(\\1))/ge"
  exec "%s/\\.stub/.stubs/ge"
  exec "%s/\\.and_raise/.raises/ge"
  write
endfunction
