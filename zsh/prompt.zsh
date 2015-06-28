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

_spaced() { [[ -n "$1" ]] && echo " $@" }

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

_git_status_symbol(){
  local letter
  # http://www.fileformat.info/info/unicode/char/2714/index.htm
  local checkmark="\u2714"
  # http://www.fileformat.info/info/unicode/char/2718/index.htm
  local x_mark="\u2718"

  case $(_git_status) in
    changed) letter=$(_red $x_mark);;
    staged) letter=$(_yellow "S");;
    untracked) letter=$(_cyan "UT");;
    unchanged) letter=$(_green $checkmark);;
  esac

  _spaced "$letter"
}

# Is this branch ahead/behind its remote tracking branch?
_git_relative_branch_status_symbol(){
  local arrow;

  # http://www.fileformat.info/info/unicode/char/21e3/index.htm
  local downwards_arrow="\u21e3"
  # http://www.fileformat.info/info/unicode/char/21e1/index.htm
  local upwards_arrow="\u21e1"
  case $(_git_relative_branch_status) in
    behind) arrow=$(_cyan $downwards_arrow);;
    ahead) arrow=$(_cyan $upwards_arrow);;
  esac

  echo -n "$arrow"
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

_git_relative_branch_status(){
  local git_status="$(cat "/tmp/git-status-$$")"
  if echo "$git_status" | grep -qF "Your branch is behind"; then
    echo "behind"
  elif echo "$git_status" | grep -qF "Your branch is ahead"; then
    echo "ahead"
  fi
}

_git_branch() {
  # vcs_info_msg_0_ is set by the `zstyle vcs_info` directives
  local colored_branch_name="$vcs_info_msg_0_"
  _spaced "$colored_branch_name"
}

# This shows everything about the current git branch:
# * branch name
# * check mark/x mark/letter etc depending on whether branch is dirty, clean,
#   has staged changes, etc
# * Up arrow if local branch is ahead of remote branch, or down arrow if local
#   branch is behind remote branch
_full_git_status(){
  if [[ -n "$vcs_info_msg_0_" ]]; then
    _spaced $(_git_branch) $(_git_status_symbol) $(_git_relative_branch_status_symbol)
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

export PROMPT="\$(ruby_version) \$(_shortened_path)\$(_full_git_status) $ "
