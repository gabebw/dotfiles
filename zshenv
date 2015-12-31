eval "$(rbenv init -)"
# Vim only sources zshenv (this file), not zshrc.
# We source homebrew here so that Vim can find Homebrew's ctags.
source ~/.zsh/homebrew.zsh
