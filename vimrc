" Stolen wholesale from christoomey, whose dotfiles you really should check out:
" https://github.com/christoomey/dotfiles
function! s:SourceConfigFilesIn(directory)
  let directory_splat = '~/.vim/' . a:directory . '/*'
  for config_file in split(glob(directory_splat), '\n')
    if filereadable(config_file)
        execute 'source' config_file
    endif
  endfor
endfunction

set nocompatible

" Vundle goes first
filetype off " required!
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" Leader is <Space>
let mapleader=" "

call s:SourceConfigFilesIn('')
call s:SourceConfigFilesIn('rcplugins')
colorscheme jellybeans
