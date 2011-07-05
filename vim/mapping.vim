" "," is the <Leader> character
let mapleader=","

" Change the current working directory to the directory that the current file you are editing is in.
map <Leader>cd :cd %:p:h <CR>
" Opens a file with the current working directory already filled in so you have to specify only the filename.
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
" Remove trailing whitespace before saving
map <Leader>w :%s/\s\+$//e<CR>
" Run scheme
"map <Leader>r :!mit-scheme --edit --load "<C-R>=expand("%:p:h") . "/" <CR>"
map <Leader>n :NERDTreeToggle<CR>

augroup rails_shortcuts
  " Rails.vim
  " Leader shortcuts for Rails commands
  " from http://github.com/ryanb/dotfiles/blob/master/vimrc
  " Rails configuration - from jferris
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

  " Steps
  autocmd User Rails map <Leader>p :Rstep
  autocmd User Rails map <Leader>tp :RTstep
  autocmd User Rails map <Leader>sp :RSstep

  " Models
  autocmd User Rails map <Leader>m :Rmodel
  autocmd User Rails map <Leader>tm :RTmodel
  autocmd User Rails map <Leader>sm :RSmodel

  " Controller
  autocmd User Rails map <Leader>c :Rcontroller
  autocmd User Rails map <Leader>tc :RTcontroller
  autocmd User Rails map <Leader>sc :RScontroller

  " Views
  autocmd User Rails map <Leader>v :Rview
  autocmd User Rails map <Leader>tv :RTview
  autocmd User Rails map <Leader>sv :RSview

  " Test
  autocmd User Rails map <Leader>u :Runittest
  autocmd User Rails map <Leader>tu :RTunittest
  autocmd User Rails map <Leader>su :RSunittest

  autocmd User Rails map <Leader>h :Rhelper
  autocmd User Rails map <Leader>i :Rintegrationtest

  autocmd User Rails map <Leader>f :Rfunctionaltest
  autocmd User Rails map <Leader>tf :RTfunctionaltest
  autocmd User Rails map <Leader>sf :RSfunctionaltest

  autocmd User Rails map <Leader>i :Rintegrationtest
  autocmd User Rails map <Leader>ti :RTintegrationtest
  autocmd User Rails map <Leader>si :RSintegrationtest

  autocmd User Rails map <Leader>g :Rconfig
  autocmd User Rails map <Leader>tg :RTconfig
  autocmd User Rails map <Leader>sg :RSconfig

  command! Rroutes :e config/routes.rb
  " When you call Rpreview <x>, use this command to open localhost:3000/<x>
  command! -bar -nargs=1 OpenURL :!open <args>
augroup END

" Move lines up and down
"map <C-J> :m +1 <CR>
"map <C-K> :m -2 <CR>
" Window navigation
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>
nmap <C-H> <C-W><C-H>

" Mappings
map :Nohl :nohlsearch
" no ex mode
map Q q
inoremap kj <Esc>
" Use apostrophe for backquote function, since backquote is so much more
" useful than apostrophe
nnoremap ` '

map <C-s> <esc>:w<cr>
imap <C-s> <esc>:w<cr>
