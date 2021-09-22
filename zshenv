# Vim only sources zshenv (this file), not zshrc.

# Add the Homebrew path here so that Vim can find Homebrew's ctags.
PATH=/usr/local/bin:/usr/local/sbin:$PATH

if [[ -r ~/.terminfo/61/alacritty ]]; then
  export TERM=alacritty
else
  export TERM=xterm-256color
fi

eval "$(rbenv init -)"

# This handles Node versions for things that only source zshenv, but zshrc is
# more complicated and so we have the setup again in zshrc.
eval "$(fnm env --use-on-cd --log-level=error)"
