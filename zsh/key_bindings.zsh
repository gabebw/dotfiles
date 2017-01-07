# Vim-style line editing
# This sets up a bunch of bindings, so call this first and then call all
# other `bindkey`s after it to override anything you like.
bindkey -v

# Fuzzy match against history, edit selected value
# For exact match, start the query with a single quote: 'curl
fuzzy-history() {
  selected=$(fc -l 1 | sed 's/^ *[0-9]* *//' | fzf --tac --reverse --no-sort)
  print -z "$selected"
}

# Ctrl-r triggers fuzzy history search
bindkey -M viins -s '^r' 'fuzzy-history\n'

# https://coderwall.com/p/jpj_6q
# Search through history for previous commands matching everything up to current
# cursor position. Move the cursor to the end of line after each match.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
