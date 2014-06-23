#######################
#  GIT (branch, vcs)  #
#######################
autoload -Uz vcs_info
# run before setting $PS1 each time
function precmd {
  vcs_info 'prompt'
  $(git status 2> /dev/null >! "/tmp/git-status-$$")
}

# colors
RESET_COLOR="%{${reset_color}%}"
BRANCH_COLOR="%{$fg_bold[yellow]%}"
STAGED_UNSTAGED_COLOR="%{$fg_bold[red]%}"

# %b: branch name, e.g. "master"
BRANCH="${BRANCH_COLOR}%b${RESET_COLOR}"
# %u: "U" if there are unstaged changes
# %c: "S" if there are staged changes
STAGED_UNSTAGED="${STAGED_UNSTAGED_COLOR}%u%c${RESET_COLOR}"

zstyle ':vcs_info:*' enable git
# Slower, but required for %u and %c codes in formats
zstyle ':vcs_info:git*' check-for-changes true

zstyle ':vcs_info:git*' formats " [$BRANCH $STAGED_UNSTAGED]"
