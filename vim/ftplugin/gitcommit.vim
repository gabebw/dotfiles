" Spell-check Git messages
setlocal spell
setlocal colorcolumn=51

nnoremap <buffer> gE :call ExpandShortGitShaIntoFullGitSha()<CR>
