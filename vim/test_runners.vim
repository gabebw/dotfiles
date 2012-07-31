" Functions for running tests

nnoremap <Leader>a :call RunCurrentTest()<CR>
nnoremap <Leader>l :call RunCurrentLineInTest()<CR>

function! CorrectTestRunner()
  let rspec="rspec --color"
  if match(expand('%'), '_spec\.rb$') != -1 || match(expand('%:p'), 'spec/integration/') != -1
    return rspec
  elseif match(expand('%:p'), 'spec/\(acceptance\|features\)/') != -1
    " Turnip
    return rspec . " -r turnip"
  elseif match(expand('%'), '\.feature$') != -1
    return "cucumber"
  elseif match(expand('%'), '_test\.rb$') != -1
    " TestUnit
    return "ruby -Itest"
  else
    return "false"
  endif
endfunction

function! RunCurrentTest()
  if CorrectTestRunner() == "false"
    echoerr "Can't run test (is this a test file?)"
  else
    let command_string = "" . CorrectTestRunner() . " " . expand('%:p')
    call Send_to_Tmux("clear\n")
    call Send_to_Tmux(command_string . "\n")
  endif
endfunction

function! RunCurrentLineInTest()
  if CorrectTestRunner() == "false"
    echoerr "Can't run test (is this a test file?)"
  else
    if CorrectTestRunner() == "ruby -Itest"
      let matcher = StringAppropriateForMatchingInTestUnit()
      if matcher == ""
        " No matched line, run the whole test.
        call RunCurrentTest()
      else
        let command_string = "" . CorrectTestRunner() . " " . expand('%:p') . " -n '/" . matcher . "/'"
        call Send_to_Tmux("clear\n")
        call Send_to_Tmux(command_string . "\n")
      endif
    else
      if match(CorrectTestRunner(), 'turnip') != -1
        " Turnip doesn't work with line numbers
        let command_string = "" . CorrectTestRunner() . " " . expand('%:p')
      else
        let command_string = "" . CorrectTestRunner() . " " . expand('%:p') . ":" . line(".")
      endif
      call Send_to_Tmux("clear\n")
      call Send_to_Tmux(command_string . "\n")
    endif
  endif
endfunction

" Returns the line number of the closest `context` or `should` *block* (so
" `should have_many(:posts)` wouldn't match), searching upwards. Meant to be
" used in Test::Unit files.
" Returns 0 if no match found.
function! LineNumberOfNearestUpwardsContextOrShouldBlock()
  " That weird concatenation is because you can't escape single quotes in a
  " single-quoted string. It should just be ["\']
  return search('^ *\(context\|should\) ["' . "']", 'bnc')
endfunction

" Return the part of the line appropriate for passing to Test::Unit for
" matching. I.E.:
"   context "should be great for us"
" would return "should be great for us".
" If no line matches, returns an empty string.
function! StringAppropriateForMatchingInTestUnit()
  let line_content = getline(LineNumberOfNearestUpwardsContextOrShouldBlock())
  " Friggin' Vim, not letting me escape quotes.
  let single_or_double_quote = '["' . "']"
  let repeated_non_quote = '[^"' . "']\\+"
  let pattern = single_or_double_quote.'\('.repeated_non_quote.'\)'.single_or_double_quote
  let result = matchlist(line_content, pattern)
  if len(result) >= 2
    return result[1]
  else
    return ""
  endif
endfunction
