augroup rails_shortcuts
  " Rails.vim
  " Leader shortcuts for Rails commands
  autocmd!
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes
  autocmd User Rails Rnavcommand initializer config/initializers -glob=**/*
  autocmd User Rails Rnavcommand factories spec test -glob=**/* -default=factories
  command! Rroutes :e config/routes.rb

  autocmd User Rails nnoremap <Leader>m :Rmodel<Space>
  autocmd User Rails nnoremap <Leader>c :Rcontroller<Space>
  autocmd User Rails nnoremap <Leader>v :Rview<Space>
  autocmd User Rails nnoremap <Leader>u :Runittest<Space>
augroup END
