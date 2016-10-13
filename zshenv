is_osx(){
  [ "$(uname -s)" = Darwin ]
}

# Vim only sources zshenv (this file), not zshrc.

# Source homebrew here so that Vim can find Homebrew's ctags.
source ~/.zsh/homebrew.zsh

# Make sure rbenv is in the $PATH when we run `rbenv` below, and thus Vim's ruby
# is correctly set
source ~/.zsh/ruby.zsh

eval "$(rbenv init -)"
