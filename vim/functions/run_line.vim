" Given your cursor is on a line like this:
"
" $ echo Hello
"
" This command strips off the dollar sign and puts the result of that command on
" the lines below.
function! RunLine()
  let command = substitute(getline('.'), "^\\$ \\?", "", "")
  let g:result = system(command)
  for line in reverse(split(g:result, "\n"))
    call append(".", line)
  endfor
endfunction

command! RunLine call RunLine()
