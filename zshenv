is_osx(){
  [ "$(uname -s)" = Darwin ]
}

# Vim only sources zshenv (this file), not zshrc.

# Add the Homebrew path here so that Vim can find Homebrew's ctags.
PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Make sure rbenv is in the $PATH when we run `rbenv` below, and thus Vim's ruby
# is correctly set
PATH=./bin/stubs:~/.rbenv/shims:~/.rbenv/bin:$PATH

eval "$(rbenv init -)"
