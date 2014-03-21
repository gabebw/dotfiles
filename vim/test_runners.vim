" Functions for running tests

" Thanks, vim-rspec!
nnoremap <Leader>a :call RunCurrentSpecFile()<CR>
nnoremap <Leader>l :call RunNearestSpec()<CR>

let g:rspec_command=':call Send_to_Tmux("clear\nrspec {spec}\n")'
