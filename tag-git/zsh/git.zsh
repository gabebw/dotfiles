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
alias gcp="git rev-parse HEAD | xargs echo -n | pbcopy"
alias gc="git checkout"
alias gcm="git commit -m"

# Checkout branches starting with my initials
function gb(){
  branch="gbw-${1#gbw-}"
  base=$2
  if [[ -n "$base" ]]; then
    git checkout -b "$branch" "$base"
  else
    git checkout -b "$branch"
  fi
}
function gbm(){ gb "$1" origin/master }

function gcl {
  local directory="$(superclone "$@")"
  cd "$directory"
}

# Complete `g` like `git`, etc
compdef g=git
compdef _git gc=git-checkout
compdef _git ga=git-add
