# Easily start a new named tmux session
function t(){
  tmux new -s "${1:-scratch}"
}

# Only do this if we're inside tmux
if [[ -n $TMUX ]]
then
  eval "$(rbenv init - --no-rehash)"

  # Vim only sources zshenv (this file), not zshrc.
  # We source homebrew here so that Vim can find Homebrew's ctags.
  source ~/.zsh/homebrew.zsh
fi
