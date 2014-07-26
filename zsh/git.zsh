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
  local git_url="$1"
  local custom_directory="$2"
  if [[ "$git_url" == tb:* ]]; then
    # Chop off the `tb:` from `tb:paperclip`
    local directory="${git_url#tb:}"
  else
    local directory="${$(basename $git_url)%.git}"
  fi

  if [[ -z "$custom_directory" ]]; then
    git clone "$git_url" && cd "$directory"
  else
    git clone "$git_url" "$custom_directory" && \
      cd "$custom_directory"
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
