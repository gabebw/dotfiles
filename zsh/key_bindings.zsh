# Vim-style line editing
bindkey -v
# I want my bck-i-search
bindkey -M viins "^r" history-incremental-search-backward
bindkey -M vicmd "f" history-incremental-search-backward
autoload zkbd
