# Vim-style line editing
bindkey -v

# Fuzzy match against history, edit selected value
fuzzy-history() {
  print -z $(fc -l 1 | \
    tail -2000 | \
    fzf --tac --reverse --no-sort | \
    sed 's/ *[0-9]* *//')
}

# Ctrl-r triggers fuzzy history search
bindkey -M viins -s '^r' 'fuzzy-history\n'
