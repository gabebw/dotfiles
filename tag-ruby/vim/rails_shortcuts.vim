" Rails.vim
augroup rails_shortcuts
  autocmd!

  let g:rails_projections = {
      \ "config/routes.rb": { "command": "routes" },
      \ "spec/factories.rb": { "command": "factories" },
      \ "app/services/*.rb": {
      \   "command": "service",
      \   "test": "spec/services/%s_spec.rb"
      \ }
  \ }

  autocmd User Rails nnoremap <Leader>m :Emodel<Space>
  autocmd User Rails nnoremap <Leader>c :Econtroller<Space>
  autocmd User Rails nnoremap <Leader>v :Eview<Space>
  autocmd User Rails nnoremap <Leader>u :Eunittest<Space>

  " Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
  let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
augroup END
