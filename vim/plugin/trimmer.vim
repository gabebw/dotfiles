" Taken from https://github.com/derekprior/vim-trimmer, then modified

" Settings:
" g:trimmer_repeated_lines_blacklist - a list of filetypes to NOT trim
" g:disable_trimmer - Set to 1 to disable the plugin. Mostly used by Enable() and
"                     Disable() and not really meant to be always set.

if !exists('g:trimmer_repeated_lines_blacklist')
  let g:trimmer_repeated_lines_blacklist = []
endif

augroup vimTrimmer
  autocmd!
  autocmd BufWritePre * call s:Trim()
augroup END

function! s:Disable()
  let g:disable_trimmer = 1
endfunction

function! s:Enable()
  let g:disable_trimmer = 0
endfunction

function! s:Trim()
  if ! get(g:, 'disable_trimmer')
    let l:pos = getpos('.')
    call s:TrimTrailingWhitespace()
    if index(g:trimmer_repeated_lines_blacklist, &filetype) < 0
      call s:TrimRepeatedBlankLines()
    endif
    call setpos('.', l:pos)
  endif
endfunction

function! s:TrimTrailingWhitespace()
  %s/\s\+$//e
endfunction

function! s:TrimRepeatedBlankLines()
  %s/\n\{3,}/\r\r/e
  %s#\($\n\s*\)\+\%$##e
  if &filetype ==? 'ruby'
    " Remove blank lines between "end"s in ruby
    %s/end\n\n\(\s*end\)/end\r\1/e
  endif
endfunction

command! EnableVimTrimmer call <SID>Enable()
command! DisableVimTrimmer call <SID>Disable()
