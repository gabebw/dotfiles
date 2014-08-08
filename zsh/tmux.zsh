####################################
# 1) Ensure we're always in a tmux session
alias current-tmux-session="tmux list-sessions | grep attached | awk '{session=sub(/:/, \"\", \$1); print \$session}' | head -1"

ensure_we_are_inside_tmux() {
  if _is_tmux_not_running; then
    _ensure_tmux_is_running
    tmux attach
  fi
}

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
# Attach if not in tmux, or switch if we are in tmux
attach_to_tmux_session() {
  local session="$1"
  if _is_tmux_not_running; then
    tmux attach -t "$1"
  else
    tmux switch-client -t "$1"
  fi
}

####################################
# 2) the `t` function

# Use `t blog` to connect to the `blog` session, or create a new session named
# `blog`.
function t {
  if (( $# == 1 )); then
    _tmux_try_to_connect_to "$1"
  else
    _new_tmux_session
  fi
 }

_tmux_session_exists(){
  local session_name="$1"
  sessions=$(tmux list-sessions | awk -F ':' '{print $1}')
  echo $sessions | grep -q "$session_name"
}

# Try to connect to a session with the given name.
# If no such session exists, create it first.
_tmux_try_to_connect_to() {
  local session_to_connect_to="${1//./-}"

  if _tmux_session_exists "$session_to_connect_to"; then
    attach_to_tmux_session "$session_to_connect_to"
  else
    _new_tmux_session_named "$session_to_connect_to"
  fi
}

# Create a new tmux session with the given name.
_new_tmux_session_named() {
  local new_session_name="$1"
  TMUX= tmux new-session -d -s "$new_session_name"
  attach_to_tmux_session "$new_session_name"
}
