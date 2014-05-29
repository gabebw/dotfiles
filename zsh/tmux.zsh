alias current-tmux-session="tmux list-sessions | grep attached | awk '{session=sub(/:/, \"\", \$1); print \$session}' | head -1"

_is_tmux_not_running() {
  [[ -z "$TMUX" ]]
}

_is_tmux_session_list_empty() {
  [[ -z $(tmux ls) ]]
}

_ensure_tmux_is_running() {
  if _is_tmux_session_list_empty; then
    # Daemonize so it doesn't auto-open the session. We just want something that
    # `tmux attach` can use.
    tmux new -d
  fi
}

attach_to_tmux() {
  if _is_tmux_not_running; then
    _ensure_tmux_is_running
    tmux attach
  fi
}
