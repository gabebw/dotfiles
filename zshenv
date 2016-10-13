is_osx(){
  [ "$(uname -s)" = Darwin ]
}

# Vim only sources zshenv (this file), not zshrc.
# We source homebrew here so that:
# - Vim can find Homebrew's ctags
# - rbenv is in the $PATH when we run `rbenv` below, and thus Vim's ruby is
#   correctly set
source ~/.zsh/homebrew.zsh

eval "$(rbenv init -)"
