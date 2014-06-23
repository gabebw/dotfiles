_color() {
  [[ -n "$1" ]] && echo "%{$fg_bold[$2]%}$1%{$reset_color%}"
}

_separate()               { [[ -n "$1" ]] && echo " $1" }
_gray()                   { echo "$(_color "$1" grey)" }
_yellow()                 { echo "$(_color "$1" yellow)" }
_green()                  { echo "$(_color "$1" green)" }
_red()                    { echo "$(_color "$1" red)" }
_cyan()                   { echo "$(_color "$1" cyan)" }
_blue()                   { echo "$(_color "$1" blue)" }

_full_path()              { echo "$(_blue "%~")" }
_working_directory()      { echo "$(_blue "%c")" }
_colored_git_status()     { echo "$(_git_prompt_color "$(_git_status)")" }

_short_colored_git_status() {
  local letter
  case $(_git_status) in
    changed) letter=" C";;
    pending) letter=" P";;
    untracked) letter=" U";;
    unchanged) letter="";;
  esac

  _git_prompt_color $letter
}

_git_status() {
  git_status=$(cat "/tmp/git-status-$$")
  if [ -n "$(echo $git_status | grep "Changes not staged")" ]; then
    echo "changed"
  elif [ -n "$(echo $git_status | grep "Changes to be committed")" ]; then
    echo "pending"
  elif [ -n "$(echo $git_status | grep "Untracked files")" ]; then
    echo "untracked"
  else
    echo "unchanged"
  fi
}

_git_prompt_color() {
  if [ -n "$1" ]; then
    current_git_status=$(_git_status)
    if [ "changed" = $current_git_status ]; then
      echo "$(_red $1)"
    elif [ "pending" = $current_git_status ]; then
      echo "$(_yellow $1)"
    elif [ "unchanged" = $current_git_status ]; then
      echo "$(_green $1)"
    elif [ "untracked" = $current_git_status ]; then
      echo "$(_cyan $1)"
    fi
  else
    echo "$1"
  fi
}

# Must use print (not echo) for ZSH colors to work
git_branch() {
  # vcs_info_msg_0_ is set by the code in vcs.zsh
  local colored_branch_name="$vcs_info_msg_0_"
  if [[ -n "$colored_branch_name" ]]
  then
    print "$colored_branch_name"
  fi
}

# Stolen from pure.zsh:
# https://github.com/sindresorhus/pure/blob/master/pure.zsh
function git_dirty {
  # check if it's dirty
  command git diff --quiet --ignore-submodules HEAD &>/dev/null
  if (($? == 1)); then
    print "$(_red "✗")"
  else
    print "$(_green "✔")"
  fi
}

# precmd is a magic function that's run each time the prompt is shown
function precmd {
  vcs_info 'prompt'
  $(git status 2> /dev/null >! "/tmp/git-status-$$")
}

export PROMPT="\$(_working_directory) \$(git_branch)\$(_short_colored_git_status) \$(git_dirty)  "
export RPROMPT="\$(ruby_version)"
