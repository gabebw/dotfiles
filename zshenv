# rbenv
if [[ -n $TMUX ]]
then
  eval "$(rbenv init - --no-rehash)"

  # Vim only sources zshenv (this file), not zshrc.
  # We source homebrew here so that Vim can find Homebrew's ctags.
  source ~/.zsh/homebrew.zsh
fi
