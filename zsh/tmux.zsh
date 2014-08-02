####################################
# 1) Ensure we're always in a tmux session
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

_tmux_session_exists(){
  local session_name="$1"
  sessions=$(tmux list-sessions | awk -F ':' '{print $1}')
  echo $sessions | grep -q "$session_name"
}


# Create a new tmux session in the fuzzy-found directory.
# If called with one argument, names the session that.
# If called with no arguments, names the session after the directory.
_new_tmux_session_via_fuzzy_finder() {
  local project
  local new_session_name
  project=$(echo "${CDPATH//:/\n}" | while read dir; do find -L "$dir" -not -path '*/\.*' -type d -maxdepth 1 -exec basename {} \;; done | fzf --reverse)
  # tmux doesn't allow session names to have dots in them, so replace with `-`
  new_session_name="${project//./-}"
  if [[ $# == 1 ]]; then
    new_session_name="${1//./-}"
  else
    new_session_name="${project//./-}"
  fi

  if ! _tmux_session_exists "$new_session_name"; then
    (cd "$project" && TMUX= tmux new-session -d -s "$new_session_name")
  fi

  attach_to_tmux_session "$new_session_name"
}

_tmux_try_to_connect_to() {
  local session_to_connect_to="$1"
  if _tmux_session_exists "$session_to_connect_to"; then
    attach_to_tmux_session "$session_to_connect_to"
  else
    _new_tmux_session_via_fuzzy_finder
  fi
}

# Fuzzy-find through directories in $CDPATH, and if a tmux session exists with
# the same name as the selected directory, switch to it; otherwise create a new
# session there.
# Via @christoomey, who's a beast.
#
# You can do `t blog` to connect to the `blog` session, or create a new session
# named `blog` at a directory of your choosing.
#
# You can do just `t` to fuzzy-find a directory, then switch to a session with
# the same name as that directory (or attach to the existing session).
function t {
  local sessions=$(tmux list-sessions | awk -F ':' '{print $1}')
  if [[ $# == 1 ]]; then
    _tmux_try_to_connect_to "$1"
  else
    _new_tmux_session_via_fuzzy_finder
  fi
 }
