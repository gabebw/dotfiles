function MatchTechWordsToAvoid()
  highlight TechWordsToAvoid ctermbg=red ctermfg=white guibg=red guifg=white
  match TechWordsToAvoid /\c\<\(obviously\|basically\|simply\|of\scourse\|clearly\|\(^\|\W\)\@<=just\(\W\)\@=\(\W\)\@<!\|everyone\sknows\|however\|so,\|easy\)\>/
endfunction

autocmd FileType markdown call MatchTechWordsToAvoid()
autocmd BufWinEnter *.md call MatchTechWordsToAvoid()
autocmd InsertEnter *.md call MatchTechWordsToAvoid()
autocmd InsertLeave *.md call MatchTechWordsToAvoid()
autocmd BufWinLeave *.md call clearmatches()
