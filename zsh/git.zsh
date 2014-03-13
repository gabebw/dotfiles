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
# Clone a URL and cd into the directory
function gcl() { git clone $1 && cd $( echo "$1" | sed -E  -e 's|[a-z]+:[a-z]+/||' -e 's|.*/(.*).git$|\1|') }
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
