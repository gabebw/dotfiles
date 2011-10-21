# Vim-style line editing
bindkey -v
# I want my bck-i-search
bindkey -M viins "^r" history-incremental-search-backward
bindkey -M vicmd "f" history-incremental-search-backward
autoload zkbd
# Create an empty $key array so that setting $key[subscript] below doesn't
# fail if $key doesn't exist
typeset -g -A key

# Set some defaults. Use -z, not -e, because we're checking that it's set to
# an empty string.
[[ -z "${key[Home]}" ]] && key[Home]='^[[H'
[[ -z "${key[End]}" ]] && key[End]='^[[F'

# Via http://dev.codemac.net/?p=config.git;a=blob_plain;f=zsh/env;h=350939a5c6b890e91a0a3bfec6e7c96c21fd8d5b
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
# This will make ZSH hesitate every time you press backspace. Don't do it.
#[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
