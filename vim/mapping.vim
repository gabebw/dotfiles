" "," is the <Leader> character
let mapleader=","

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
  autocmd!
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes
  autocmd User Rails Rnavcommand initializer config/initializers -glob=**/*
  autocmd User Rails Rnavcommand factories spec test -glob=**/* -default=factories

  " Steps
  autocmd User Rails nnoremap <Leader>p :Rstep<Space>
  autocmd User Rails nnoremap <Leader>vp :RVstep<Space>
  autocmd User Rails nnoremap <Leader>sp :RSstep<Space>

  " Models
  autocmd User Rails nnoremap <Leader>m :Rmodel<Space>
  autocmd User Rails nnoremap <Leader>vm :RVmodel<Space>
  autocmd User Rails nnoremap <Leader>sm :RSmodel<Space>

  " Controller
  autocmd User Rails nnoremap <Leader>c :Rcontroller<Space>
  autocmd User Rails nnoremap <Leader>vc :RVcontroller<Space>
  autocmd User Rails nnoremap <Leader>sc :RScontroller<Space>

  " Views
  autocmd User Rails nnoremap <Leader>v :Rview<Space>
  autocmd User Rails nnoremap <Leader>vv :RVview<Space>
  autocmd User Rails nnoremap <Leader>sv :RSview<Space>

  " Test
  autocmd User Rails nnoremap <Leader>u :Runittest<Space>
  autocmd User Rails nnoremap <Leader>vu :RVunittest<Space>
  autocmd User Rails nnoremap <Leader>su :RSunittest<Space>

  autocmd User Rails nnoremap <Leader>h :Rhelper<Space>
  autocmd User Rails nnoremap <Leader>vh :RVhelper<Space>
  autocmd User Rails nnoremap <Leader>sh :RShelper<Space>

  autocmd User Rails nnoremap <Leader>i :Rintegrationtest<Space>
  autocmd User Rails nnoremap <Leader>vi :RVintegrationtest<Space>
  autocmd User Rails nnoremap <Leader>si :RSintegrationtest<Space>

  command! Rroutes :e config/routes.rb
  " When you call Rpreview <x>, use this command to open localhost:3000/<x>
  command! -bar -nargs=1 OpenURL :!open <args>

  command! -nargs=+ Cuc :!ack --no-heading --no-break <q-args> | cut -d':' -f1,2 | xargs bundle exec cucumber --no-color
augroup END

" Git
nnoremap <Leader>gc :Gcommit -m ""<LEFT>
nnoremap <Leader>gcv :Gcommit -v<CR>
nnoremap <Leader>ga :Git add .<CR>
" Show blame info for selected text (via Mike Burns)
vnoremap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

nnoremap <Leader>ctags :!ctags -f 'tmp/tags' -R --langmap="ruby:+.rake.builder.rjs" .<CR>

" Buffer navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Disable K looking stuff up
nnoremap K <Nop>
nnoremap :Nohl :nohlsearch
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
