#################
#  ZSH options  #
#################
HISTFILE=~/.zsh_history
export HISTSIZE=1000000000000000000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE
setopt no_list_beep
setopt no_beep
setopt appendhistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt autocd
setopt prompt_subst
setopt autopushd

unsetopt correctall
# Allow [ or ] whereever you want
# (Prevents "zsh: no matches found: ...")
unsetopt nomatch
