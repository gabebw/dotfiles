" Rails.vim
augroup rails_shortcuts
  autocmd!

  let g:rails_projections = {
      \ "config/routes.rb": { "command": "routes" },
      \ "spec/factories.rb": { "command": "factories" },
      \ "spec/features/*_spec.rb": { "command": "feature" },
      \ "app/services/*.rb": {
      \   "command": "service",
      \   "test": "spec/services/%s_spec.rb"
      \ },
      \ "app/jobs/*_job.rb": {
      \   "command": "job",
      \   "template": "class %SJob < ActiveJob::Job\nend",
      \   "test": [
      \     "spec/jobs/%s_job_spec.rb"
      \   ]
      \ },
  \ }

  autocmd User Rails nnoremap <Leader>m :Emodel<Space>
  autocmd User Rails nnoremap <Leader>c :Econtroller<Space>
  autocmd User Rails nnoremap <Leader>v :Eview<Space>
  autocmd User Rails nnoremap <Leader>u :Eunittest<Space>

  " Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
  let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
augroup END
