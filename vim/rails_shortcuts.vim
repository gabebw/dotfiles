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
