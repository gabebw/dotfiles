# Vim-specific things are in here (versus being in `~/.zshrc`) because Vim's
# `:!command`s are run in a non-interactive shell, which only sources
# `~/.zshenv` (this file).

if [ -n "$VIMRUNTIME" ]; then
  # Add the Homebrew path here so that Vim can find Homebrew's ctags.
  MY_HOMEBREW_PREFIX=$(brew --prefix)
  PATH="$MY_HOMEBREW_PREFIX"/bin:"$MY_HOMEBREW_PREFIX"/sbin:$PATH

  eval "$(rbenv init -)"

  # This handles Node versions for things that only source zshenv, but zshrc is
  # more complicated and so we have the setup again in zshrc.
  eval "$(fnm env --use-on-cd --log-level=error)"
fi
. "$HOME/.cargo/env"
