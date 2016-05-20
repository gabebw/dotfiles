####################################
# 1) Ensure we're always in a tmux session

ensure_we_are_inside_tmux() {
  if _not_in_tmux; then
    _ensure_tmux_is_running
    tmux attach -t "$(_most_recent_tmux_session)"
  fi
}

# Returns the name of the most recent tmux session, sorted by time the session
# was last attached.
_most_recent_tmux_session(){
  tmux list-sessions -F "#{session_last_attached} #{session_name}" | \
    sort -r | \
    cut -d' ' -f2 | \
    head -1
}

_not_in_tmux() {
  [[ -z "$TMUX" ]]
}

_no_tmux_sessions() {
  [[ -z $(tmux ls) ]]
}

_ensure_tmux_is_running() {
  if _no_tmux_sessions; then
    # Daemonize so it doesn't auto-open the session. We just want something that
    # `tmux attach` can use.
    tmux new -d
  fi
}

# Attach if not in tmux, or switch if we are in tmux
attach_to_tmux_session() {
  local session="$1"
  if _not_in_tmux; then
    tmux attach -d -t "$1"
  else
    tmux switch-client -t "$1"
  fi
}

####################################
# 2) the `t` function

# Use `t blog` to connect to the `blog` session, or create a new session named
# `blog`.
#
# With no arguments, lists all tmux sessions.
function t {
  if (( $# == 1 )); then
    _tmux_try_to_connect_to "$1"
  else
    tmux list-sessions -F "#{session_name}"
  fi
 }

_tmux_session_exists(){
  tmux list-sessions -F "#{session_name}" | egrep -q "^${1}$"
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

  # Create three windows named vim/scratch/server and jump into the first one
  TMUX= tmux new-session -d -As "$new_session_name" -n vim
  tmux new-window -t "$new_session_name" -n scratch
  tmux new-window -t "$new_session_name" -n server
  tmux select-window -t "$new_session_name" -n
  tmux attach -t "$session_name"
}
