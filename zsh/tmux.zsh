alias copy-from-tmux="tmux saveb - | pbcopy"

alias current-tmux-session="tmux list-sessions | grep attached | awk '{session=sub(/:/, \"\", \$1); print \$session}'"

# gem install tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

if [[ -z $TMUX ]]
then
  # Autocomplete the t() function from ~/.zshenv
  _tmux-new-or-attach () {
      compadd $(tmux list-session | awk -F: '{print $1}')
  }
  compdef _tmux-new-or-attach t
fi
