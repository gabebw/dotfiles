TMUX_PROJECT_DIRECTORY=$HOME/.tmux-project-directory

mkdir -p $TMUX_PROJECT_DIRECTORY

function current-project-path() {
  echo "$TMUX_PROJECT_DIRECTORY/`current-tmux-session`"
}

cdpath=($HOME/thoughtbot/ $HOME/thoughtbot/* $HOME/Projects $HOME/src)

function chpwd {
  echo $(pwd) >! `current-project-path`
}

current() {
  if [[ -f `current-project-path` ]]; then
    cd "$(cat `current-project-path`)"
  fi
}

current
