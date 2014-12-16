" Change ctrl-p.vim binding
let g:ctrlp_map = '<Leader>t'

" Make CtrlP use ag for listing the files. Way faster and no useless files.
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" Disable caching, ag is fast enough
let g:ctrlp_use_caching = 0
