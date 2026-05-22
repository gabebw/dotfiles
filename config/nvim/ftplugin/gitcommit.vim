" Spell-check Git messages
setlocal spell
setlocal colorcolumn=51

if line('$') > 5000
  " Do not auto-format (and so on) on write, as it can take huge amounts of memory and time on a 27,000+ line
  " merge commit
  setlocal eventignore+=BufWritePre,BufWritePost
endif
