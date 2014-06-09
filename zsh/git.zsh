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

alias gp="bundle exec rake && git push"

# Clone a URL and cd into the directory.
# Handles the following `git clone` schemes:
# * git@github.com:thoughtbot/paperclip.git
# * wgh:thoughtbot/paperclip
# * tb:paperclip
function gcl {
  local gitpath="$1"
  local to_clone_into="$2"
  local directory=""

  if [[ "$to_clone_into" == "" ]]; then
    directory=$(echo "$gitpath" | sed -E -e 's/git@github.com://' -e 's/.git$//' -e 's|^[^/]+/||' -e 's/^[a-z]+://')
    git clone "$gitpath" && cd "$directory"
  else
    git clone "$gitpath" "$to_clone_into" && cd "$to_clone_into"
  fi
}

alias gd="git diff"
alias gs="git show"
# Grep with grouped output like Ack
alias gg="git g"
alias amend="git commit --amend -Chead"
alias amend-new="git commit --amend"

alias ga="git add"
alias gai="git add --interactive"

function gb(){ git checkout -b gbw-$1 $2 }

alias gc="git checkout"
alias gcm="git commit -m"

# Complete `g` like `git`, etc
compdef g=git
compdef _git gc=git-checkout
compdef _git ga=git-add
