# allows e.g. $fg[blue] and $bg[green]
autoload -Uz colors && colors

# http://zsh.sourceforge.net/Doc/Release/Completion-System.html
zmodload -i zsh/complist

# Colorful lists of possible autocompletions
# Set to an empty string to use default colors
zstyle ':completion:*' list-colors ''

# Show ls on dark backgrounds well
unset LSCOLORS
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS=gxfxcxdxbxegedabagacad
