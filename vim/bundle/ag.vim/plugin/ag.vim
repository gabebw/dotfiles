" NOTE: You must, of course, install the ag script
"       in your path.
" On Debian / Ubuntu:
"   sudo apt-get install ag-grep
" On your vimrc:
"   let g:agprg="ag-grep -H --nocolor --nogroup --column"
"
" With MacPorts:
"   sudo port install p5-app-ag

" Location of the ag utility
if !exists("g:agprg")
	let g:agprg="ag --nogroup --column"
endif

function! s:Ag(cmd, args)
    redraw
    echo "Searching ..."

    " If no pattern is provided, search for the word under the cursor
    if empty(a:args)
        let l:grepargs = expand("<cword>")
    else
        let l:grepargs = a:args
    end

    " Format, used to manage column jump
    if a:cmd =~# '-g$'
        let g:agformat="%f"
    else
        let g:agformat="%f:%l:%c:%m"
    end

    let grepprg_bak=&grepprg
    let grepformat_bak=&grepformat
    try
        let &grepprg=g:agprg
        let &grepformat=g:agformat
        silent execute a:cmd . " " . l:grepargs
    finally
        let &grepprg=grepprg_bak
        let &grepformat=grepformat_bak
    endtry

    if a:cmd =~# '^l'
        botright lopen
    else
        botright copen
    endif

    exec "nnoremap <silent> <buffer> q :ccl<CR>"
    exec "nnoremap <silent> <buffer> t <C-W><CR><C-W>T"
    exec "nnoremap <silent> <buffer> T <C-W><CR><C-W>TgT<C-W><C-W>"
    exec "nnoremap <silent> <buffer> o <CR>"
    exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"
    exec "nnoremap <silent> <buffer> v <C-W><C-W><C-W>v<C-L><C-W><C-J><CR>"
    exec "nnoremap <silent> <buffer> gv <C-W><C-W><C-W>v<C-L><C-W><C-J><CR><C-W><C-J>"

    " If highlighting is on, highlight the search keyword.
    if exists("g:aghighlight")
        let @/=a:args
        set hlsearch
    end

    redraw!
endfunction

function! s:AgFromSearch(cmd, args)
    let search =  getreg('/')
    " translate vim regular expression to perl regular expression.
    let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
    call s:Ag(a:cmd, '"' .  search .'" '. a:args)
endfunction

command! -bang -nargs=* -complete=file Ag call s:Ag('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file AgAdd call s:Ag('grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file AgFromSearch call s:AgFromSearch('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LAg call s:Ag('lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LAgAdd call s:Ag('lgrepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file AgFile call s:Ag('grep<bang> -g', <q-args>)
