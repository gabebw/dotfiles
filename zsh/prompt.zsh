#######################
#  GIT (branch, vcs)  #
#######################
autoload -Uz vcs_info

RESET_COLOR="%{${reset_color}%}"
BRANCH_COLOR="%{$fg_bold[yellow]%}"
BRANCH="${BRANCH_COLOR}%b${RESET_COLOR}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "$BRANCH"

##################
# Non-git things #
##################

_color() {
  [[ -n "$1" ]] && echo "%{$fg_bold[$2]%}$1%{$reset_color%}"
}

_gray()       { echo "$(_color "$1" grey)" }
_yellow()     { echo "$(_color "$1" yellow)" }
_green()      { echo "$(_color "$1" green)" }
_red()        { echo "$(_color "$1" red)" }
_cyan()       { echo "$(_color "$1" cyan)" }
_blue()       { echo "$(_color "$1" blue)" }
_magenta()    { echo "$(_color "$1" magenta)" }

_full_path()         { echo "$(_blue "%~")" }
_working_directory() { echo "$(_blue "%c")" }


ruby_version() {
  local version=`rbenv version-name`
  _magenta "$version"
}

_short_colored_git_status() {
  local letter
  local separator="/"
  case $(_git_status) in
    changed) letter="C";;
    pending) letter="P";;
    staged) letter="S";;
    untracked) letter="UT";;
    unchanged) letter="";;
  esac

  if [[ -n "$letter" ]]; then
    echo -n "$(_blue "$separator")"
    _color_based_on_git_status $letter
  fi
}

_git_status() {
  local git_status="$(cat "/tmp/git-status-$$")"
  if echo "$git_status" | grep -q "Changes not staged" ; then
    echo "changed"
  elif echo "$git_status" | grep -q "Changes to be committed"; then
    echo "staged"
  elif echo "$git_status" | grep -q "Untracked files"; then
    echo "untracked"
  else
    echo "unchanged"
  fi
}

_color_based_on_git_status() {
  if [ -n "$1" ]; then
    local current_git_status=$(_git_status)

    case "$current_git_status" in
      changed) echo "$(_red $1)" ;;
      staged) echo "$(_yellow $1)" ;;
      untracked) echo "$(_cyan $1)" ;;
      unchanged) echo "$(_green $1)" ;;
    esac
  else
    echo "$1"
  fi
}

# Must use print (not echo) for ZSH colors to work
git_branch() {
  # vcs_info_msg_0_ is set by the vcs_info directives at the top of this file
  local colored_branch_name="$vcs_info_msg_0_"
  if [[ -n "$colored_branch_name" ]]
  then
    print " $colored_branch_name"
  fi
}

# precmd is a magic function that's run each time the prompt is shown
function precmd {
  vcs_info 'prompt'
  $(git status 2> /dev/null >! "/tmp/git-status-$$")
}

# OK, now actually set PROMPT and RPROMPT
export PROMPT="\$(_working_directory)\$(git_branch)\$(_short_colored_git_status) "
export RPROMPT="\$(ruby_version)"
