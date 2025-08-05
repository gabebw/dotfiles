# Vim-specific things are in here (versus being in `~/.zshrc`) because Vim's
# `:!command`s are run in a non-interactive shell, which only sources
# `~/.zshenv` (this file).

# Alacritty runs some unknown command with `zsh -c` every time a new window
# opens, which means that this file gets run.
# I use the fish shell, so I only want this stuff to run inside Vim.  To
# ensure that, we check for `$VIMRUNTIME`, which should really only be set
# when running `:!command` inside Vim.
# This is fixed in this merged but unreleased PR: https://github.com/alacritty/alacritty/pull/7950
if [ -n "$VIMRUNTIME" ]; then
  # Add the Homebrew path here so that Vim can find Homebrew's ctags.
  MY_HOMEBREW_PREFIX=$(brew --prefix)
  PATH="$MY_HOMEBREW_PREFIX"/bin:"$MY_HOMEBREW_PREFIX"/sbin:$PATH

  if [[ -r ~/.terminfo/61/alacritty ]]; then
    export TERM=alacritty
  else
    export TERM=xterm-256color
  fi

  eval "$(rbenv init -)"

  # This handles Node versions for things that only source zshenv, but zshrc is
  # more complicated and so we have the setup again in zshrc.
  eval "$(fnm env --use-on-cd --log-level=error)"
fi
. "$HOME/.cargo/env"
