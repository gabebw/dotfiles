" "," is the <Leader> character
let mapleader=","

" For Ben
inoremap <F1> <Esc>

" Change the current working directory to the directory that the current file you are editing is in.
nnoremap <Leader>cd :cd %:p:h <CR>
" Opens a file with the current working directory already filled in so you have to specify only the filename.
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
nnoremap <Leader>v :vsplit <C-R>=expand("%:p:h") . '/'<CR>
" Remove trailing whitespace
nnoremap <Leader>w :%s/\s\+$//e<CR>
nnoremap <Leader>n :40Vexplore<CR> " 40 columns wide

function! CorrectTestRunner()
  if match(expand('%'), '\.feature$') != -1
    return "cucumber --drb"
  elseif match(expand('%'), '_spec\.rb$') != -1
     return "rspec --drb"
   endif
endfunction

function! RunCurrentTest()
  exec "!" . CorrectTestRunner() . " " . expand('%:p')
endfunction

function! RunCurrentLineInTest()
  exec "!" . CorrectTestRunner() . " " . expand('%:p') . ":" . line(".")
endfunction

nnoremap <Leader>a :call RunCurrentTest()<CR>
nnoremap <Leader>l :call RunCurrentLineInTest()<CR>

augroup rails_shortcuts
  " Rails.vim
  " Leader shortcuts for Rails commands
  " from http://github.com/ryanb/dotfiles/blob/master/vimrc
  " Rails configuration - from jferris
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes
  autocmd User Rails Rnavcommand initializer config/initializers -glob=**/*
  autocmd User Rails Rnavcommand factories spec test -glob=**/* -default=factories

  " Steps
  autocmd User Rails nmap <Leader>p :Rstep<Space>
  autocmd User Rails nmap <Leader>vp :RVstep<Space>
  autocmd User Rails nmap <Leader>sp :RSstep<Space>

  " Models
  autocmd User Rails nmap <Leader>m :Rmodel<Space>
  autocmd User Rails nmap <Leader>vm :RVmodel<Space>
  autocmd User Rails nmap <Leader>sm :RSmodel<Space>

  " Controller
  autocmd User Rails nmap <Leader>c :Rcontroller<Space>
  autocmd User Rails nmap <Leader>vc :RVcontroller<Space>
  autocmd User Rails nmap <Leader>sc :RScontroller<Space>

  " Views
  autocmd User Rails nmap <Leader>v :Rview<Space>
  autocmd User Rails nmap <Leader>vv :RVview<Space>
  autocmd User Rails nmap <Leader>sv :RSview<Space>

  " Test
  autocmd User Rails nmap <Leader>u :Runittest<Space>
  autocmd User Rails nmap <Leader>vu :RVunittest<Space>
  autocmd User Rails nmap <Leader>su :RSunittest<Space>

  autocmd User Rails nmap <Leader>h :Rhelper<Space>
  autocmd User Rails nmap <Leader>vh :RVhelper<Space>
  autocmd User Rails nmap <Leader>sh :RShelper<Space>

  autocmd User Rails nmap <Leader>i :Rintegrationtest<Space>
  autocmd User Rails nmap <Leader>vi :RVintegrationtest<Space>
  autocmd User Rails nmap <Leader>si :RSintegrationtest<Space>

  command! Rroutes :e config/routes.rb
  " When you call Rpreview <x>, use this command to open localhost:3000/<x>
  command! -bar -nargs=1 OpenURL :!open <args>

  command! -nargs=+ Cuc :!ack --no-heading --no-break <q-args> | cut -d':' -f1,2 | xargs bundle exec cucumber --no-color
augroup END

" Git
nmap <Leader>gc :Gcommit -m ""<LEFT>
nmap <Leader>gcv :Gcommit -v<CR>
nmap <Leader>ga :Git add .<CR>
" Show blame info for selected text (via Mike Burns)
vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

nmap <Leader>ctags :!ctags -f 'tmp/tags' -R --langmap="ruby:+.rake.builder.rjs" .<CR>

" Move lines up and down
"map <C-J> :m +1 <CR>
"map <C-K> :m -2 <CR>
" Window navigation
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>
nmap <C-H> <C-W><C-H>

" Disable K looking stuff up
nmap K <Nop>

" Mappings
nmap :Nohl :nohlsearch
" no ex mode
map Q <Nop>
inoremap kj <Esc>
" Use apostrophe for backquote function, since backquote is so much more
" useful than apostrophe
nnoremap ` '

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Chapter 7
nnoremap <Leader>sv :source $MYVIMRC<CR>
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>

" Chapter 9
" double-quote selected text
vnoremap <Leader>z "zdi""<ESC>"zPgvl
" Stronger h
nnoremap H 0
" Stronger l
nnoremap L $

" Chapter 13
autocmd FileType javascript :iabbrev <buffer> iff if ( ) {}<left><left><left><left><left>
autocmd FileType python :iabbrev <buffer> iff if:<left>
