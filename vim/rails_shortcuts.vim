augroup rails_shortcuts
  " Rails.vim
  " Leader shortcuts for Rails commands
  autocmd!
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes
  autocmd User Rails Rnavcommand initializer config/initializers -glob=**/*
  autocmd User Rails Rnavcommand factories spec test -glob=**/* -default=factories
  autocmd User Rails Rnavcommand routes config/routes.rb
  command! Rroutes :e config/routes.rb

  " Models
  autocmd User Rails nnoremap <Leader>m :Rmodel<Space>
  autocmd User Rails nnoremap <Leader>mv :RVmodel<Space>
  autocmd User Rails nnoremap <Leader>ms :RSmodel<Space>

  " Controller
  autocmd User Rails nnoremap <Leader>c :Rcontroller<Space>
  autocmd User Rails nnoremap <Leader>cv :RVcontroller<Space>
  autocmd User Rails nnoremap <Leader>cs :RScontroller<Space>

  " Views
  autocmd User Rails nnoremap <Leader>v :Rview<Space>
  autocmd User Rails nnoremap <Leader>vv :RVview<Space>
  autocmd User Rails nnoremap <Leader>vs :RSview<Space>

  " Test
  autocmd User Rails nnoremap <Leader>u :Runittest<Space>
  autocmd User Rails nnoremap <Leader>uv :RVunittest<Space>
  autocmd User Rails nnoremap <Leader>us :RSunittest<Space>
augroup END
