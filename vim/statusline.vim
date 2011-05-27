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
" clear statusline
set statusline=
set statusline+=%{fugitive#statusline()}
" %2* means invert the background/foreground colors
set statusline+=%2*
" space at the end
" Add empty quotes at end so that removing trailing whitespace won't remove
" that space
set statusline+=\ ""

" buffer number
set statusline+=%2*buf:\ %-3.3n%0*
" %f = Path to the file in the buffer, as typed or relative to current
" directory. %t = file basename
set statusline+=%f
" FLAGS
" %m = display "[+]" if file has been modified
" %r = display "[RO]" if file is read-only
" %h = help buffer flag, "[help]"
" %w = [Preview] if in preview window
" %y = file content type, e.g. "[ruby]" - includes brackets
" %{&ff} = file format (unix/dos)
set statusline+=%m%r%h%w%y\ fmt=%{&ff} " flags
set statusline+=\  " add a space
" %l = current line number
" %L = total lines
" %c = current column
set statusline+=lin\:%l/%L\ col\:%c " line and column
" %= = right-align everything after this
set statusline+=%= " right align
" last modified time, like "07/29/10 07:36:44"
set statusline+=%{strftime(\"%m/%d/%y\ %T\",getftime(expand(\"%:p\")))}
