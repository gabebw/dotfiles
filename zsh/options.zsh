#################
#  ZSH options  #
#################
HISTFILE=~/.zsh_history
export HISTSIZE=1000000000000000000
export SAVEHIST=$HISTSIZE
setopt no_list_beep
setopt no_beep
# Append as you type (incrementally) instead of on shell exit
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt autocd
setopt autopushd
# Timestamp history entries
setopt extended_history

unsetopt correctall
# Allow [ or ] wherever you want
# (Prevents "zsh: no matches found: ...")
unsetopt nomatch
