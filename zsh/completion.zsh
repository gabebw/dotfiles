################
#  COMPLETION  #
################
fpath=(~/.dotfiles/zsh/completion-scripts /usr/local/share/zsh/site-functions $fpath)
autoload -U compinit && compinit
