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
call plug#begin('~/.vim/bundle')
source ~/.vim/plugins.vim
" Load plugins from various tags (~/.vim/plugins/*)
" For example, tag-haskell/vim/plugins/haskell.vim is linked to
" ~/.vim/plugins/haskell.vim.
call s:SourceConfigFilesIn('plugins')
call plug#end()
call s:SourceConfigFilesIn('')
call s:SourceConfigFilesIn('functions')
call s:SourceConfigFilesIn('rcplugins') " after plugins load

" Turn on syntax highlighting and filetype detection.
" vim-plug loads all the extra syntax and ftdetect files, so turn them on after
" we load plugins.
filetype plugin indent on
syntax enable
colorscheme 1989
