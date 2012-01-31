################
#  COMPLETION  #
################
fpath=(~/.dotfiles/zsh/completion-scripts $fpath)
autoload -U compinit && compinit

# complete viw like `which`
compdef viw=which
