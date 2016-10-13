inside_ssh(){
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
}

if ! inside_ssh; then
  source "$BASE/tmux.zsh"
  ensure_we_are_inside_tmux
fi
