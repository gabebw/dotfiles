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

# Clone a git URL and cd into the directory.
#
# `gcl URL floo` will clone the URL into a directory named floo, just like
# `git clone URL floo`.
#
# If there's a URL in the clipboard, just do `gcl` without arguments and it will
# use that.
#
# You can even do `gcl git clone URL` and it will act like `gcl URL`.
#
# Handles the following `git clone` schemes (search `insteadOf` in gitconfig for
# explanations of the weird ones):
# * git@github.com:thoughtbot/paperclip.git
# * https://github.com/rails/rails.git
# * wgh:thoughtbot/paperclip
# * tb:paperclip
function gcl {
  # Did "gcl git clone URL", remove the "git clone"
  if [[ "$1" == "git" && "$2" == "clone" ]]; then
    shift;
    shift;
  fi

  # No arguments provided, assume we should use the clipboard
  if (( $# == 0 )); then
    gcl $(pbpaste)
    return
  fi

  local git_url="$1"
  local custom_directory="$2"
  if [[ "$git_url" == tb:* ]]; then
    # Chop off the `tb:` from `tb:paperclip` since `basename` won't change it.
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
