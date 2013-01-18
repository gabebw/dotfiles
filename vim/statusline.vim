" http://vim.runpaint.org/display/changing-status-line/
" http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
" Status line detail:
" %F = file name ("~/.vimrc")
" %t = file BASENAME (".vimrc")
" strftime.... = time
"   (See: http://vim.wikia.com/wiki/Insert_current_date_or_time)
" getftime = last modification time
" %P = ??? something with percentage ???
set laststatus=2 " always display status line

" This is a function so that it can be called by autocmd. We need autocmd
" because exists("*fugitive#statusline") fails if it's called during the
" sourcing of plugins, so we call it after everything's loaded, to test for
" fugitive.
function! statusline#set()
  " :help cterm-colors
  " Background: DarkGreen
  " Foreground: White
  hi StatusLine ctermbg=2 ctermfg=15

  " clear statusline
  set statusline=

  if exists("*fugitive#statusline")
    set statusline+=%{fugitive#statusline()}
  else
    echoerr "Fugitive is not installed, please run :BundleInstall"
  endif

  " space at the end
  " Add empty quotes at end so that removing trailing whitespace won't remove
  " that space
  set statusline+=\ ""

  " buffer number
  set statusline+=buf:\ %-3.3n%0*
  " %f = Path to the file in the buffer, as typed or relative to current
  " directory. %t = file basename
  set statusline+=%.30F " Print at most 30 chars of the full path to the file
  " FLAGS
  " %m = display "[+]" if file has been modified
  " %r = display "[RO]" if file is read-only
  " %h = help buffer flag, "[help]"
  " %w = [Preview] if in preview window
  " %y = file content type, e.g. "[ruby]" - includes brackets
  " %{&ff} = file format (unix/dos)
  set statusline+=%m%r%h%w%y\ fmt=%{&ff} " flags
  set statusline+=\  " add a space
  " %= = right-align everything after this
  set statusline+=%= " right align
  " last modified time, like "07/29/10 07:36:44"
  set statusline+=last\ modified:\ %{strftime(\"%m/%d/%y\ %T\",getftime(expand(\"%:p\")))}
endfunction

augroup statusline
  autocmd!
  autocmd VimEnter * call statusline#set()
augroup END
