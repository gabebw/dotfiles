# This file allows new tmux windows/panes to open in the last-cd'ed-directory of
# their session. It is scoped to the session, so new panes in the `foo` session
# don't auto-cd to the same place as new panes in the `bar` session.

TMUX_PROJECT_DIRECTORY=$HOME/.tmux-project-directory

mkdir -p $TMUX_PROJECT_DIRECTORY

function current-project-path() {
  echo "$TMUX_PROJECT_DIRECTORY/`current-tmux-session`"
}

cdpath=($HOME/code $HOME/code/*)

function chpwd {
  echo $(pwd) >! `current-project-path`
}

current() {
  if [[ -f `current-project-path` ]]; then
    cd "$(cat `current-project-path`)"
  fi
}

current
