#######
# Git #
#######
function g {
  if [[ $# > 0 ]]; then
    git $@
  else
    git st
  fi
}
compdef g=git
alias gp="bundle exec rake && git push"
alias gci="git pull --rebase && brake && git push"
alias gcl="git clone"
alias gd="git diff"
alias gg="git grep"
alias amend="git commit --amend -Chead"
alias amend-new="git commit --amend"

alias ga="git add"
alias gai="git add --interactive"

alias gb="git checkout -b"
alias gc="git checkout"
alias gs="git st" # Use my alias from ~/.gitconfig
alias gcm="git commit -m"
