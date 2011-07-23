" "," is the <Leader> character
let mapleader=","

" Change the current working directory to the directory that the current file you are editing is in.
map <Leader>cd :cd %:p:h <CR>
" Opens a file with the current working directory already filled in so you have to specify only the filename.
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
map <Leader>s :split <C-R>=expand("%:p:h") . '/'<CR>
map <Leader>v :vnew <C-R>=expand("%:p:h") . '/'<CR>
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
  autocmd User Rails map <Leader>p :Rstep<Space>
  autocmd User Rails map <Leader>vp :RVstep<Space>
  autocmd User Rails map <Leader>sp :RSstep<Space>

  " Models
  autocmd User Rails map <Leader>m :Rmodel<Space>
  autocmd User Rails map <Leader>vm :RVmodel<Space>
  autocmd User Rails map <Leader>sm :RSmodel<Space>

  " Controller
  autocmd User Rails map <Leader>c :Rcontroller<Space>
  autocmd User Rails map <Leader>vc :RVcontroller<Space>
  autocmd User Rails map <Leader>sc :RScontroller<Space>

  " Views
  autocmd User Rails map <Leader>v :Rview<Space>
  autocmd User Rails map <Leader>vv :RVview<Space>
  autocmd User Rails map <Leader>sv :RSview<Space>

  " Rake
  autocmd User Rails map <Leader>t :.Rake!<CR>
  autocmd User Rails map <Leader>tt :Rake!<CR>

  " Test
  autocmd User Rails map <Leader>u :Runittest<Space>
  autocmd User Rails map <Leader>vu :RVunittest<Space>
  autocmd User Rails map <Leader>su :RSunittest<Space>

  autocmd User Rails map <Leader>h :Rhelper<Space>
  autocmd User Rails map <Leader>vh :RVhelper<Space>
  autocmd User Rails map <Leader>sh :RShelper<Space>

  autocmd User Rails map <Leader>i :Rintegrationtest<Space>
  autocmd User Rails map <Leader>vi :RVintegrationtest<Space>
  autocmd User Rails map <Leader>si :RSintegrationtest<Space>

  autocmd User Rails map <Leader>g :Rconfig<Space>
  autocmd User Rails map <Leader>vg :RVconfig<Space>
  autocmd User Rails map <Leader>sg :RSconfig<Space>

  autocmd User Rails map <Leader>j :Rjavascript<Space>
  autocmd User Rails map <Leader>vj :RVjavascript<Space>
  autocmd User Rails map <Leader>sj :RSjavascript<Space>

  map <Leader>sc :sp db/schema.rb<CR>

  command! Rroutes :e config/routes.rb
  " When you call Rpreview <x>, use this command to open localhost:3000/<x>
  command! -bar -nargs=1 OpenURL :!open <args>
augroup END

" Git
map <Leader>gc :Gcommit -m ""<LEFT>
map <Leader>gcv :Gcommit -v<CR>
map <Leader>ga :Git add .<CR>

map <Leader>ctags :!ctags -f 'tmp/tags' -R --langmap="ruby:+.rake.builder.rjs" .

" Move lines up and down
"map <C-J> :m +1 <CR>
"map <C-K> :m -2 <CR>
" Window navigation
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>
nmap <C-H> <C-W><C-H>

" Disable K looking stuff up
map K <Nop>

" Mappings
map :Nohl :nohlsearch
" no ex mode
map Q <Nop>
inoremap kj <Esc>
" Use apostrophe for backquote function, since backquote is so much more
" useful than apostrophe
nnoremap ` '

map <C-s> <esc>:w<cr>
imap <C-s> <esc>:w<cr>
