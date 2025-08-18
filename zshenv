# Vim-specific things are in here (versus being in `~/.zshrc`) because Vim's
# `:!command`s are run in a non-interactive shell, which only sources
# `~/.zshenv` (this file).

if [ -n "$VIMRUNTIME" ]; then
  # Add the Homebrew path here so that Vim can find Homebrew's ctags.
  MY_HOMEBREW_PREFIX=$(brew --prefix)
  PATH="$MY_HOMEBREW_PREFIX"/bin:"$MY_HOMEBREW_PREFIX"/sbin:$PATH

  eval "$(mise activate zsh)"
fi
. "$HOME/.cargo/env"
