if [[ -n $TMUX ]]
then
  # We're in tmux, go go go
  eval "$(rbenv init - --no-rehash)"

  # Vim only sources zshenv (this file), not zshrc.
  # We source homebrew here so that Vim can find Homebrew's ctags.
  source ~/.zsh/homebrew.zsh
else
  # Easily start a new named tmux session
  function t(){
    session_name="${1:-scratch}"
    tmux new -s "$session_name" || tmux attach -t "$session_name"
  }

  echo
  echo '>> Use `t [session-name]` to start tmux <<'
  echo
fi
