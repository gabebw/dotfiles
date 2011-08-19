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

  " Rake
  autocmd User Rails nmap <Leader>o :.Rake!<CR>
  autocmd User Rails nmap <Leader>t :Rake!<CR>

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

  autocmd User Rails nmap <Leader>g :Rconfig<Space>
  autocmd User Rails nmap <Leader>vg :RVconfig<Space>
  autocmd User Rails nmap <Leader>sg :RSconfig<Space>

  autocmd User Rails nmap <Leader>j :Rjavascript<Space>
  autocmd User Rails nmap <Leader>vj :RVjavascript<Space>
  autocmd User Rails nmap <Leader>sj :RSjavascript<Space>

  map <Leader>sc :sp db/schema.rb<CR>

  command! Rroutes :e config/routes.rb
  " When you call Rpreview <x>, use this command to open localhost:3000/<x>
  command! -bar -nargs=1 OpenURL :!open <args>

  command! -nargs=+ Cuc :!ack --no-heading --no-break <q-args> | cut -d':' -f1,2 | xargs bundle exec cucumber --no-color
augroup END

" Git
map <Leader>gc :Gcommit -m ""<LEFT>
map <Leader>gcv :Gcommit -v<CR>
map <Leader>ga :Git add .<CR>
" Show blame info for selected text (via Mike Burns)
vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

map <Leader>ctags :!ctags -f 'tmp/tags' -R --langmap="ruby:+.rake.builder.rjs" .<CR>

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
