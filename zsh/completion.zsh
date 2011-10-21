################
#  COMPLETION  #
################
fpath=(~/.dotfiles/zsh/completion-scripts $fpath)
autoload -U compinit && compinit

# complete command names, inc. aliases, shell functions, builtins and reserved
# words.
#compctl -m viw
# complete viw like `which`
compdef viw=which
