#######################
#  GIT (branch, vcs)  #
#######################
autoload -Uz vcs_info
# run before setting $PS1 each time
function precmd { vcs_info 'prompt'; }
# colors
RESET_COLOR="%{${reset_color}%}"
BRANCH_COLOR="%{$fg[red]%}"
PAREN_COLOR="%{$fg[green]%}"

PAREN_OPEN="${PAREN_COLOR}(${RESET_COLOR}"
PAREN_CLOSE="${PAREN_COLOR})${RESET_COLOR}"

BASIC_BRANCH="${BRANCH_COLOR}%b${RESET_COLOR}" # e.g. "master"
# Note leading space!
PRETTY_BRANCH=" ${PAREN_OPEN}${BASIC_BRANCH}${PAREN_CLOSE}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats $PRETTY_BRANCH
