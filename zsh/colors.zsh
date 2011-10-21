############
#  COLORS  #
############
# allows e.g. $fg[blue] and $bg[green]
autoload -Uz colors && colors
zmodload -i zsh/complist # colorful listings
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
