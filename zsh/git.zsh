#######
# Git #
#######

# By itself: run `git status`
# With arguments: acts like `git`
function g {
  if [[ $# > 0 ]]; then
    git $@
  else
    git st
  fi
}

alias gd="git diff"
# Grep with grouped output like Ack
alias gg="git g"
alias amend="git commit --amend -Chead"
alias amend-new="git commit --amend"

alias ga="git add"
alias gai="git add --interactive"

# `cd` doesn't work in shell scripts because each one runs in its own subshell.
# So `superclone` returns the name of the directory to `cd` into and we run `cd`
# as a function in this shell. It's all very silly.
function gcl {
  local directory="$(superclone "$@")"
  cd "$directory"
}

function gb(){ git checkout -b gbw-$1 $2 }

alias gc="git checkout"
alias gcm="git commit -m"

# Complete `g` like `git`, etc
compdef g=git
compdef _git gc=git-checkout
compdef _git ga=git-add
