# This file allows new tmux windows/panes to open in the last-cd'ed-directory of
# their session. It is scoped to the session, so new panes in the `foo` session
# don't auto-cd to the same place as new panes in the `bar` session.

TMUX_PROJECT_DIRECTORY="$HOME/.tmux-project-directory"

mkdir -p "$TMUX_PROJECT_DIRECTORY"

function current-project-path() {
  current_tmux_session="$(tmux display-message -p '#S')"
  echo "${TMUX_PROJECT_DIRECTORY}/${current_tmux_session}"
}

function chpwd {
  echo "$(pwd)" >! "$(current-project-path)"
}

current() {
  if [[ -f "$(current-project-path)" ]]; then
    cd "$(cat "`current-project-path`")"
  fi
}
