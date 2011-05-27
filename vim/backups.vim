" With backup and writebackup on, it overwrites the old backup
set backup
set writebackup
set backupdir=~/.vim/backups
" setting backupskip to this to allow for 'crontab -e' using vim.
" thanks to: http://tim.theenchanter.com/2008/07/crontab-temp-file-must-be-edited-in.html
if has('unix')
  set backupskip=/tmp/*,/private/tmp/*"
endif

" views options
set viewdir=~/.vim/views
" http://github.com/tpope/vim-rails/issues/closed/#issue/25
" Having these mkview lines make rails.vim not work (lots of "File not in
" path" errors.
" Match all files but don't trigger when opening vim without a file
"autocmd BufWinLeave ?* mkview
"autocmd BufWinEnter ?* silent loadview
