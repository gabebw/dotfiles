# vim: foldmethod=marker

# Prompt colors {{{
#-------------------

typeset -AHg fg
typeset -Hg reset_color
fg=(
  green 158
  magenta 218
  purple 146
  red 197
  cyan 159
  blue 031
  yellow 222
)

# Add escape codes to the hex codes above
for k in ${(k)fg}; do
  # "\e[38;5;" means "set the following color as the foreground color"
  fg[$k]="\e[38;5;${fg[$k]}m"
done
# This is always defined as the "default foreground color", which might be white
# on a dark background or black on a white background.
reset_color="\e[39m"

prompt_color()  { print "%{$fg[$2]%}$1%{$reset_color%}" }
prompt_green()  { prompt_color "$1" green }
prompt_magenta(){ prompt_color "$1" magenta }
prompt_purple() { prompt_color "$1" purple }
prompt_red()    { prompt_color "$1" red }
prompt_cyan()   { prompt_color "$1" cyan }
prompt_blue()   { prompt_color "$1" blue }
prompt_yellow() { prompt_color "$1" yellow }
prompt_spaced() { [[ -n "$1" ]] && print " $@" }
# }}}

# Helper functions: path and Ruby version {{{
#--------------------------------------------
# %2~ means "show the last two components of the path, and show the home
# directory as ~".
#
# Examples:
#
# ~/foo/bar is shown as "foo/bar"
# ~/foo is shown as ~/foo (not /Users/gabe/foo)
prompt_shortened_path(){ prompt_purple "%2~" }

# "2.7.1" -> "2.7.1"
# "rbenv: version `2.6.6' is not installed (set by /Users/gabe/.ruby-version)" -> "!!2.6.6 not installed"
prompt_pretty_uncolored_ruby_version(){
  local version=$(rbenv version-name 2>&1)
  case "$version" in
    *'not installed'*) sed 's/.*version .(.+). is not installed.*/!!\1 not installed/' <<<"$version";;
    *) print "$version";;
  esac
}

prompt_ruby_version() {
  prompt_magenta "$(prompt_pretty_uncolored_ruby_version)"
}

prompt_node_version(){
  local v="$(volta list --format plain | rg '^runtime' | sed 's/.*node@([0-9.]+).*/\1/g')"
  if [[ -n "$v" ]]; then
    # Note the space after the variable
    prompt_blue "$v "
  fi
}
# }}}

# Git-related prompt stuff {{{
#-----------------------------

# vcs_info docs: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats $(prompt_blue "%b")
zstyle ':vcs_info:git*' actionformats $(prompt_red "%b|%a")

prompt_git_status_symbol(){
  local symbol
  local clean=$(prompt_green ✔)
  local dirty=$(prompt_red ✘)
  local untracked=$(prompt_cyan '?')
  local staged=$(prompt_yellow S)
  local conflicts=$(prompt_red '!')

  case $(prompt_git_status) in
    changed) symbol=$dirty;;
    staged) symbol=$staged;;
    untracked) symbol=$untracked;;
    unchanged) symbol=$clean;;
    conflicts) symbol=$conflicts;;
    *) symbol=ugh;;
  esac

  print "$symbol"
}

# Is this branch ahead/behind its remote tracking branch?
prompt_git_relative_branch_status_symbol(){
  local symbol;
  local downwards_arrow=$(prompt_cyan ↓)
  local upwards_arrow=$(prompt_cyan ↑)
  local sideways_arrow=$(prompt_red ⇔)
  local good=$(prompt_green ✔)
  local question_mark=$(prompt_yellow \?)

  case $(prompt_git_relative_branch_status) in
    not_tracking) symbol=$question_mark;;
    up_to_date) symbol=$good;;
    ahead_behind) symbol=$sideways_arrow;;
    behind) symbol=$downwards_arrow;;
    ahead) symbol=$upwards_arrow;;
    upstream_gone) symbol="[upstream gone]";;
    *) symbol=ugh
  esac

  prompt_spaced "$symbol"
}

prompt_git_raw_status(){
  # Get the cached status from /tmp/git-status-$$ if possible.
  # Otherwise, fall back to running `git status`.
  # The cached status won't be there after returning to the terminal after some
  # time away (since /tmp gets cleared). When the cached status file isn't
  # there, it shows `ugh` in the prompt, even though it could figure out the
  # status.
  #
  # To avoid that false status, fall back to running `git status`.
  cat /tmp/git-status-$$ 2>/dev/null || git status 2>/dev/null
}

prompt_git_status() {
  local git_status=$(prompt_git_raw_status)
  case "$git_status" in
  *"Changes not staged"*) print "changed";;
  *"Changes to be committed"*) print "staged";;
  *"Untracked files"*) print "untracked";;
  *"working tree clean"*) print "unchanged";;
  *"Unmerged paths"*) print "conflicts";;
  esac
}

prompt_git_relative_branch_status(){
  local git_status=$(prompt_git_raw_status)
  # Calling `git rev-parse HEAD` in a brand-new repository without any commits
  # prints a long error message. Suppress it by redirecting STDERR.
  local branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if ! git config --get "branch.${branch_name}.merge" > /dev/null; then
    print "not_tracking"
  else
    case "$git_status" in
      *up?to?date*) print "up_to_date";;
      *"have diverged"*) print "ahead_behind";;
      *"Your branch is behind"*) print "behind";;
      *"Your branch is ahead"*) print "ahead";;
      *"upstream is gone"*) print "upstream_gone";;
    esac
  fi
}

prompt_git_branch() {
  # vcs_info_msg_0_ is set by the `zstyle vcs_info` directives
  # It is the colored branch name.
  print "$vcs_info_msg_0_"
}

# This shows everything about the current git branch:
# * branch name
# * check mark/x mark/letter etc depending on whether branch is dirty, clean,
#   has staged changes, etc
# * Up arrow if local branch is ahead of remote branch, or down arrow if local
#   branch is behind remote branch
prompt_full_git_status(){
  if [[ -n "$vcs_info_msg_0_" ]]; then
    prompt_spaced "$(prompt_git_branch) $(prompt_git_status_symbol)$(prompt_git_relative_branch_status_symbol)"
  fi
}

# `precmd` is a magic function that's run right before the prompt is evaluated
# on each line.
# Here, it's used to capture the git status to show in the prompt.
function precmd {
  vcs_info
  if [[ -n "$vcs_info_msg_0_" ]]; then
    git status 2> /dev/null >! "/tmp/git-status-$$"
  fi
}

# Do I have a custom git email set for this git repo? Announce it so I remember
# to unset it.
prompt_git_email(){
  git_email=$(git config user.email)
  global_git_email=$(git config --global user.email)
  git_name=$(git config user.name)
  global_git_name=$(git config --global user.name)
  x=""

  if [[ "$git_email" != "$global_git_email" ]]; then
    x=" $(prompt_red "[git email: $git_email]")"
  fi

  if [[ "$git_name" != "$global_git_name" ]]; then
    x="${x} $(prompt_red "[git name: $git_name]")"
  fi
  print "$x"
}

prompt_tmux_status(){
  if _not_in_tmux && ! in_vs_code; then
    prompt_red '[!t] '
  fi
}

# }}}

# prompt_subst allows `$(function)` inside the PROMPT, which will be re-evaluated
# whenever the prompt is displayed. Don't put the PROMPT in double quotes, which
# will immediately evaluate the "$(code)".
setopt prompt_subst

PROMPT='$(prompt_tmux_status)$(prompt_ruby_version) $(prompt_node_version)$(prompt_shortened_path)$(prompt_git_email)$(prompt_full_git_status) $ '
