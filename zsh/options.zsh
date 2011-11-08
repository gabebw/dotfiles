#################
#  ZSH options  #
#################
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt no_list_beep
setopt no_beep
setopt appendhistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt autocd
cdpath=($HOME/thoughtbot $HOME/src)
setopt prompt_subst
setopt autopushd

unsetopt correctall
