#######################
#  GIT (branch, vcs)  #
#######################
autoload -Uz vcs_info

RESET_COLOR="%{${reset_color}%}"
BRANCH_COLOR="%{$fg_bold[yellow]%}"
BRANCH="${BRANCH_COLOR}%b${RESET_COLOR}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "$BRANCH"
