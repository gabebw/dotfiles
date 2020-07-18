call ale#Set('ruby_ruby_prettier_executable', 'rbprettier')
call ale#Set('ruby_ruby_prettier_use_global', 1)
call ale#Set('ruby_ruby_prettier_options', '')

function! ale#fixers#ruby_prettier#GetExecutable(buffer) abort
  let l:executable = ale#Var(a:buffer, 'ruby_ruby_prettier_executable')
  let l:options = ale#Var(a:buffer, 'ruby_ruby_prettier_options')

  return ale#ruby#EscapeExecutable(l:executable, 'rbprettier')
        \ . ' --parser ruby'
        \ . (!empty(l:options) ? ' ' . l:options : '')
        \ . ' --stdin-filepath %s --stdin'
endfunction

function! ale#fixers#ruby_prettier#Fix(buffer) abort
  return { 'command': ale#fixers#ruby_prettier#GetExecutable(a:buffer) }
endfunction

call ale#fix#registry#Add('ruby_prettier',
      \ 'ale#fixers#ruby_prettier#Fix',
      \ ['ruby'],
      \ 'Fix Ruby files with Prettier')
