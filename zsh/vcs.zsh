#######################
#  GIT (branch, vcs)  #
#######################
autoload -Uz vcs_info
# run before setting $PS1 each time
function precmd { vcs_info 'prompt'; }

# colors
RESET_COLOR="%{${reset_color}%}"
BRANCH_COLOR="%{$fg[red]%}"

# e.g. "master"
BRANCH="${BRANCH_COLOR}%b${RESET_COLOR}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats " $BRANCH"
