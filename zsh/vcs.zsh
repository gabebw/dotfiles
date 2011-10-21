#######################
#  GIT (branch, vcs)  #
#######################
autoload -Uz vcs_info
# run before setting $PS1 each time
function precmd { vcs_info 'prompt'; }
# colors
PR_RESET="%{${reset_color}%}"
BRANCH="%{$fg[red]%}"
PAREN_COLOR="%{$fg[green]%}"
PAREN_OPEN="${PAREN_COLOR}(%f"
PAREN_CLOSE="${PAREN_COLOR})%f"
BASIC_BRANCH="${BRANCH}%b${PR_RESET}" # e.g. "master"
FMT_BRANCH="${PAREN_OPEN}${BASIC_BRANCH}${PAREN_CLOSE}" # add parens

zstyle ':vcs_info:*' enable git hg svn
# Note leading space!
zstyle ':vcs_info:*' formats " ${FMT_BRANCH}${PR_RESET}"
