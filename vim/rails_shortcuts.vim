" Rails.vim
augroup rails_shortcuts
  autocmd!

  let g:rails_projections = {
      \ "config/routes.rb": { "command": "routes" }
  \ }

  autocmd User Rails nnoremap <Leader>m :Rmodel<Space>
  autocmd User Rails nnoremap <Leader>c :Rcontroller<Space>
  autocmd User Rails nnoremap <Leader>v :Rview<Space>
  autocmd User Rails nnoremap <Leader>u :Runittest<Space>

  " Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
  let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
augroup END
