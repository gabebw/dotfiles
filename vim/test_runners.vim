" Functions for running tests

" Export just the commands that I want to be globally available.
command! RunCurrentTest call <SID>RunCurrentTest()
command! RunCurrentLineInTest call <SID>RunCurrentLineInTest()

nnoremap <Leader>a :RunCurrentTest<CR>
nnoremap <Leader>l :RunCurrentLineInTest<CR>

function! s:TestType()
  if match(expand('%'), '_spec\.rb$') != -1
    return "rspec"
  elseif match(expand('%'), '\.feature$') != -1
    return "cucumber"
  elseif match(expand('%'), '_test\.rb$') != -1
    return "test_unit"
  elseif match(expand('%'), 'spec/javascripts/[a-z].*\.\(coffee\|js\)$') != -1
    return "javascript"
  endif
endfunction

function! s:CorrectTestRunner()
  let type_to_runner = {
    \ 'rspec': 'rspec',
    \ 'cucumber': 'cucumber',
    \ 'test_unit': 'ruby -Itest',
    \ 'javascript': 'teaspoon'
  \}

  let test_runner = get(type_to_runner, s:TestType(), 'NOT A TEST')
  return test_runner
endfunction

function! s:RunCurrentTest()
  let correct_test_runner = s:CorrectTestRunner()
  if correct_test_runner == 'NOT A TEST'
    echoerr "Can't run test (is this a test file?)"
  else
    let command_string = "" . correct_test_runner . " " . expand('%:p')
    call Send_to_Tmux("clear\n")
    call Send_to_Tmux(command_string . "\n")
  endif
endfunction

function! s:RunCurrentLineInTest()
  let correct_test_runner = s:CorrectTestRunner()
  if correct_test_runner == "ruby -Itest"
    let matcher = s:StringAppropriateForMatchingInTestUnit()
    if matcher == ""
      " No matched line, run the whole test.
      call s:RunCurrentTest()
    else
      let command_string = "" . correct_test_runner . " " . expand('%:p') . " -n '/" . matcher . "/'"
      call Send_to_Tmux("clear\n")
      call Send_to_Tmux(command_string . "\n")
    endif
  else
    let command_string = "" . correct_test_runner . " " . expand('%:p') . ":" . line(".")
    call Send_to_Tmux("clear\n")
    call Send_to_Tmux(command_string . "\n")
  endif
endfunction

" Returns the line number of the closest `context` or `should` *block* (so
" `should have_many(:posts)` wouldn't match), searching upwards. Meant to be
" used in Test::Unit files.
" Returns 0 if no match found.
function! s:LineNumberOfNearestUpwardsContextOrShouldBlock()
  " That weird concatenation is because you can't escape single quotes in a
  " single-quoted string. It should just be ["\']
  return search('^ *\(context\|should\) ["' . "']", 'bnc')
endfunction

" Return the part of the line appropriate for passing to Test::Unit for
" matching. I.E.:
"   context "should be great for us"
" would return "should be great for us".
" If no line matches, returns an empty string.
function! s:StringAppropriateForMatchingInTestUnit()
  let line_content = getline(s:LineNumberOfNearestUpwardsContextOrShouldBlock())
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
