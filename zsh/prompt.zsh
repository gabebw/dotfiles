##########
# Colors #
###########

# autoload docs: http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html
# colors provides `$fg_bold` etc: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Other-Functions
autoload -Uz colors && colors

prompt_color() {
  [[ -n "$1" ]] && echo "%{$fg_bold[$2]%}$1%{$reset_color%}"
}

prompt_gray()   { echo "$(prompt_color "$1" grey)" }
prompt_yellow() { echo "$(prompt_color "$1" yellow)" }
prompt_green()  { echo "$(prompt_color "$1" green)" }
prompt_red()    { echo "$(prompt_color "$1" red)" }
prompt_cyan()   { echo "$(prompt_color "$1" cyan)" }
prompt_blue()   { echo "$(prompt_color "$1" blue)" }
prompt_magenta(){ echo "$(prompt_color "$1" magenta)" }

prompt_spaced() { [[ -n "$1" ]] && echo " $@" }

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
prompt_shortened_path() { echo "$(prompt_blue "%2~")" }

prompt_ruby_version() {
  local version=$(rbenv version-name)
  prompt_magenta "$version"
}

#######################
#  GIT (branch, vcs)  #
#######################
#
# vcs_info docs: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats $(prompt_yellow "%b")

prompt_git_status_symbol(){
  local letter
  # http://www.fileformat.info/info/unicode/char/2714/index.htm
  local checkmark="\u2714"
  # http://www.fileformat.info/info/unicode/char/2718/index.htm
  local x_mark="\u2718"

  case $(prompt_git_status) in
    changed) letter=$(prompt_red $x_mark);;
    staged) letter=$(prompt_yellow "S");;
    untracked) letter=$(prompt_cyan "UT");;
    unchanged) letter=$(prompt_green $checkmark);;
  esac

  prompt_spaced "$letter"
}

# Is this branch ahead/behind its remote tracking branch?
prompt_git_relative_branch_status_symbol(){
  local arrow;

  # http://www.fileformat.info/info/unicode/char/21e3/index.htm
  local downwards_arrow="\u21e3"
  # http://www.fileformat.info/info/unicode/char/21e1/index.htm
  local upwards_arrow="\u21e1"
  case $(prompt_git_relative_branch_status) in
    behind) arrow=$(prompt_cyan $downwards_arrow);;
    ahead) arrow=$(prompt_cyan $upwards_arrow);;
  esac

  echo -n "$arrow"
}

prompt_git_status() {
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

prompt_git_relative_branch_status(){
  local git_status="$(cat "/tmp/git-status-$$")"
  if echo "$git_status" | grep -qF "Your branch is behind"; then
    echo "behind"
  elif echo "$git_status" | grep -qF "Your branch is ahead"; then
    echo "ahead"
  fi
}

prompt_git_branch() {
  # vcs_info_msg_0_ is set by the `zstyle vcs_info` directives
  local colored_branch_name="$vcs_info_msg_0_"
  prompt_spaced "$colored_branch_name"
}

# This shows everything about the current git branch:
# * branch name
# * check mark/x mark/letter etc depending on whether branch is dirty, clean,
#   has staged changes, etc
# * Up arrow if local branch is ahead of remote branch, or down arrow if local
#   branch is behind remote branch
prompt_full_git_status(){
  if [[ -n "$vcs_info_msg_0_" ]]; then
    prompt_spaced $(prompt_git_branch) $(prompt_git_status_symbol) $(prompt_git_relative_branch_status_symbol)
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

export PROMPT="\$(prompt_ruby_version) \$(prompt_shortened_path)\$(prompt_full_git_status) $ "
