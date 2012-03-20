" With backup and writebackup on, it overwrites the old backup
set backup
set writebackup
set backupdir=~/.vim/backups
" setting backupskip to this to allow for 'crontab -e' using vim.
" thanks to: http://tim.theenchanter.com/2008/07/crontab-temp-file-must-be-edited-in.html
if has('unix')
  set backupskip=/tmp/*,/private/tmp/*"
endif
