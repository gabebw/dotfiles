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

export PROMPT="\$(_working_directory)\$(git_branch) \$(git_dirty)  "
export RPROMPT="\$(ruby_version)"
