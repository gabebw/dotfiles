##########
# Colors #
###########

# autoload docs: http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html
# colors provides `$fg_bold` etc: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Other-Functions
autoload -Uz colors && colors

_color() {
  [[ -n "$1" ]] && echo "%{$fg_bold[$2]%}$1%{$reset_color%}"
}

_gray()   { echo "$(_color "$1" grey)" }
_yellow() { echo "$(_color "$1" yellow)" }
_green()  { echo "$(_color "$1" green)" }
_red()    { echo "$(_color "$1" red)" }
_cyan()   { echo "$(_color "$1" cyan)" }
_blue()   { echo "$(_color "$1" blue)" }
_magenta(){ echo "$(_color "$1" magenta)" }

###########################################
# Helper functions: path and Ruby version #
###########################################

# %2~ means "show the last two components of the path, and show the home
# directory as ~".
#
# Examples:
#
# ~/foo/bar is shown as "foo/bar"
# ~/foo is shown as ~/foo (not /Users/gabe/foo)
_shortened_path() { echo "$(_blue "%2~")" }

ruby_version() {
  local version=$(rbenv version-name)
  _magenta "$version"
}

#######################
#  GIT (branch, vcs)  #
#######################
#
# vcs_info docs: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information

autoload -Uz vcs_info

RESET_COLOR="%{$reset_color%}"
BRANCH_COLOR="%{$fg_bold[yellow]%}"
BRANCH="${BRANCH_COLOR}%b${RESET_COLOR}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "$BRANCH"

_short_colored_git_status() {
  local letter
  # http://www.fileformat.info/info/unicode/char/2713/index.htm
  local checkmark="\u2713"
  case $(_git_status) in
    changed) letter=$(_red "C");;
    staged) letter=$(_yellow "S");;
    untracked) letter=$(_cyan "UT");;
    unchanged) letter=$(_green $checkmark);;
  esac

  if [[ -n "$letter" ]]; then
    echo " $letter"
  fi
}

_git_status() {
  local git_status="$(cat "/tmp/git-status-$$")"
  if echo "$git_status" | grep -qF "Changes not staged" ; then
    echo "changed"
  elif echo "$git_status" | grep -qF "Changes to be committed"; then
    echo "staged"
  elif echo "$git_status" | grep -qF "Untracked files"; then
    echo "untracked"
  elif echo "$git_status" | grep -qF "working directory clean"; then
    echo "unchanged"
  fi
}

git_branch() {
  # vcs_info_msg_0_ is set by the `zstyle vcs_info` directives
  local colored_branch_name="$vcs_info_msg_0_"
  if [[ -n "$colored_branch_name" ]]; then
    echo " $colored_branch_name"
  fi
}

# `precmd` is a magic function that's run right before the prompt is evaluated
# on each line.
# Here, it's used to capture the git status to show in the prompt.
function precmd {
  vcs_info "prompt"
  git status 2> /dev/null >! "/tmp/git-status-$$"
}

###########################
# Actually set the PROMPT #
###########################

# prompt_subst allows `$(function)` inside the PROMPT
# Escape the `$()` like `\$()` so it's not immediately evaluated when this file
# is sourced but is evaluated every time we need the prompt.
setopt prompt_subst

export PROMPT="\$(ruby_version) \$(_shortened_path)\$(git_branch)\$(_short_colored_git_status) $ "
