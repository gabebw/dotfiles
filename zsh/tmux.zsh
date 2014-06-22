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

# Fuzzy-find through directories in $CDPATH, and if a tmux session exists with
# the same name as the selected directory, switch to it; otherwise create a new
# session there.
# Via @christoomey, who's a beast.
function t {
  local project
  local session
  local sessions
  project=$(echo "${CDPATH//:/\n}" | while read dir; do find -L "$dir" -not -path '*/\.*' -type d -maxdepth 1 -exec basename {} \;; done | fzf --reverse)
  sessions=$(tmux list-sessions | awk -F ':' '{print $1}')
  # tmux doesn't allow session names to have dots in them, so replace with `-`
  session_name="${project//./-}"
  if echo $sessions | grep -q "$session_name"; then
    tmux switch-client -t "$session_name"
  else
    (cd "$project" && TMUX= tmux new-session -d -s "$session_name")
    tmux switch-client -t "$session_name"
  fi
 }
