alias copy-from-tmux="tmux saveb - | pbcopy"

alias current-tmux-session="tmux list-sessions | grep attached | awk '{session=sub(/:/, \"\", \$1); print \$session}'"
