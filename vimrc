" Stolen wholesale from christoomey, whose dotfiles you really should check out:
" https://github.com/christoomey/dotfiles
function! s:SourceConfigFilesIn(directory)
  let directory_splat = '~/.vim/' . a:directory . '/*.vim'
  for config_file in split(glob(directory_splat), '\n')
    if filereadable(config_file)
        execute 'source' config_file
    endif
  endfor
endfunction

" Leader is <Space>
" <Leader> must be set before `s:SourceConfigFilesIn` below
" because leader is used at the moment mappings are defined.
" Changing mapleader after a mapping is defined has no effect on the mapping.
let mapleader=" "

" Source the rest of the configuration
call s:SourceConfigFilesIn('')
call s:SourceConfigFilesIn('functions')
call s:SourceConfigFilesIn('rcplugins') " after plugins load

" Turn on syntax highlighting and filetype detection.
" vim-plug loads all the extra syntax and ftdetect files, so turn them on after
" we load plugins.
filetype plugin indent on
syntax on
colorscheme jellybeans
