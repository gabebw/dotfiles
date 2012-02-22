
augroup LevelUp
  au!
  " Highlight characters that go past the 80-char limit in red
  autocmd BufNewFile,BufRead /Users/gabe/thoughtbot/levelup/* let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
  autocmd BufNewFile,BufRead /Users/gabe/thoughtbot/levelup/* set colorcolumn=81
augroup END
