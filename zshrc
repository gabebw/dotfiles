# tmux {{{
connect_to_most_recent_tmux_session() {
  if _not_in_tmux && _any_tmux_sessions; then
    tmux attach -t "$(_most_recent_tmux_session)"
  fi
}

# Returns the name of the most recent tmux session, sorted by time the session
# was last attached.
_most_recent_tmux_session(){
  tmux list-sessions -F "#{session_last_attached} #{session_name}" | \
    sort -r | \
    cut -d' ' -f2 | \
    head -1
}

_not_in_tmux() {
  [[ -z "$TMUX" ]]
}

_any_tmux_sessions() {
  [[ -n "$(tmux ls 2>/dev/null)" ]]
}

inside_ssh(){
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
}

in_vs_code(){ [[ "$TERM_PROGRAM" == "vscode" ]] }

if ! inside_ssh && ! in_vs_code; then
  connect_to_most_recent_tmux_session
fi
# }}}

# Aliases {{{
alias va="vim ~/.aliases"
q(){ vim "$(readlink ~/.zshrc)" }
alias qq="cd . && source ~/.zshrc"
alias cp="cp -iv"
alias rm="rm -iv"
alias mv="mv -iv"
alias ls="ls -FGh"
alias du="du -cksh"
alias df="df -h"
# Use modern regexps for sed, i.e. "(one|two)", not "\(one\|two\)"
alias sed="sed -E"
# Just print request/response headers, ignoring ~/.curlrc
curl-debug(){
  # --disable must be the first argument
  command curl \
    --disable \
    --verbose \
    --silent \
    --show-error \
    --output /dev/null \
    -H Fastly-debug:1 \
    "$@" \
    2>&1
}
# Search for the string anywhere in the command name, not just in the executable
alias pgrep='command pgrep -f'
alias split-on-spaces='tr " " "\n"'
# dup = "dotfiles update"
alias dup="pushd dotfiles && git checkout main &>/dev/null && git pull && git checkout - &>/dev/null && popd && qq"
alias ...="cd ../.."
# Copy-pasting `$ python something.py` works
alias \$=''
alias diff="command diff --color=auto -u"
alias mkdir="command mkdir -p"
alias serialnumber="ioreg -l | rg IOPlatformSerialNumber | cut -d= -f2 | sed 's/[ \"]//g'"
alias prettyjson="jq ."
# xmllint is from `brew install libxml2`
alias prettyxml="xmllint --format -"
alias prettyjavascript="prettier --stdin-filepath=any-name-here.js"
# Make images smaller
alias pngcrush=/Applications/ImageOptim.app/Contents/MacOS/ImageOptim
# Remove EXIF data
alias exif-remove="exiftool -all= "
alias hexdump=hexyl
youtube-dl-safe(){
  # Allow passing arguments in; without this, xargs treats the arguments as
  # URLs. This block assumes all arguments are at the beginning, and stops
  # reading when it sees something that's not an argument.
  local args=()
  for arg in "$@"; do
    if [[ "$arg" =~ "^-" ]]; then
      args+=("$arg")
      shift
    else
      break
    fi
  done
  print -s "youtube-dl-safe ${args:q} ${@:q}"
  # Prefer ffmpeg because avconv gives these errors:
  #   ERROR: av_interleaved_write_frame(): Invalid argument
  echo "$@" | xargs -P 5 -n 1 youtube-dl --no-check-certificate --ignore-errors --no-mtime --no-overwrites --prefer-ffmpeg --add-metadata --continue $args }
y(){
  echo "${@:-"$(pbpaste)"}"
  youtube-dl-safe "${@:-"$(pbpaste)"}"
}

# Files created today
alias today="days 0"
# Created in last n days
days(){
  local query="kMDItemFSCreationDate>\$time.today(-$1) && kMDItemContentType != public.folder"
  mdfind -onlyin . "$query"
}
epoch(){
  if [[ $# == 0 ]]; then
    # Print the current epoch
    date +%s
  else
    # Parse the given epoch
    date -r "$1"
  fi
}
alias install-command-line-tools='xcode-select --install'
rcup(){
  if ! command rcup -v | grep -v identical; then
    true
  fi
}

it(){ icopy -t tumblr/"${*// /-}" }
tcd(){
  local directory
  local session_name
  if [[ $# == 1 ]]; then
    directory=$1
    if [[ "$directory" == "." ]]; then
      directory=$(greadlink -f "$directory")
    fi
    session_name=$(basename "$1")
  elif [[ $# == 2 ]]; then
    directory=$1
    session_name=$2
  fi
  (cd "$directory" && t "$session_name")
}
null_terminate_filenames(){ tr '\n' '\0' }
xo(){ null_terminate_filenames | xargs -o -0 "${@:-open}" }
# [xo] with an [a]pp
xoa(){ xo open -a "$1" }

# seamlessly do `xargs mv` and have it work the way you want.
# `-J` requires BSD xargs, which is on OS X.
xmv(){ null_terminate_filenames | xargs -0 -J % mv % "$@" }
alias trust='mkdir -p .git/safe'
alias htop="command htop --sort-key=PERCENT_CPU"
findall(){ find . -iname "*$@*" }
alias fd='command fd --no-ignore --ignore-case --full-path --type file'
alias xee="open -a Xee³"
if [[ -r ~/.rgrc ]]; then
  export RIPGREP_CONFIG_PATH=~/.rgrc
fi
export BAT_CONFIG_PATH="~/.config/bat/config"
alias cat=bat

o(){
  if [[ -d "$1" ]]; then
    # Order matters (ugh):
    # * `-print -quit` needs to be at the end
    # * `-type` and the `-name` clauses need to be next to each other
    if [[ -n "$(find "$1" -type f \( -name '*.mp4' -or -name '*.flv' -or -name '*.mov' \) -print -quit)" ]]; then
      # \+ means the results are concatenated and the command is executed once
      # with all found results.
      find "$1" -type f \( -name '*.mp4' -or -name '*.flv' -or -name '*.mov' \) -exec open {} \+
    else
      # Unfortunately, Xee doesn't set kMDItemLastUsedDate on files when you
      # open their containing directory.
      xee "$@"
    fi
  else
    if [[ $# == 0 ]]; then
      # Are there any images in this directory?
      if [[ -n *.{png,jpg}(#qN) ]]; then
        xee .
      else
        open *.*
      fi
    else
      open "$@"
    fi
  fi
}

# Get word N (up to N = 9) from a line
word(){ awk "{ print \$$1 }" }

run-until-succeeds(){ until "$@"; do; sleep 1; done }

# `-` by itself will act like `cd -`. Needs to be a function because `alias -`
# breaks.
function -() { cd - }

# Psh, "no nodename or servname not provided". I'll do `whois
# http://google.com/hello` if I want.
whois() {
  command whois $(echo "$1" | sed -E -e 's|^https?://||' -e 's|/.*$||g')
}

al(){
  if [[ -d "$1" ]]; then
    lister -n 10 -s modified "$1"
  else
    lister "$@"
  fi
}

alr() {
  if [[ $# == 0 ]]; then
    ls -t -r | head -n 10
  elif [[ $# == 1 && $1 =~ '^[0-9]+$' ]]; then
    ls -t -r | head -n "$1"
  else
    ls -t -r "$@" | head -n 10
  fi
}

# If piping something in, copy it.
# If just doing `clip`, paste it.
clip() { [ -t 0 ] && pbpaste || pbcopy;}

# Cut out a segment of a video
cut-video(){
  if [[ $# != 4 ]]; then
    echo "Cut a video from 1hr-1hr30m and output to OUT.mp4:"
    echo "    cut VIDEO.mp4 1:00:00 1:30:00 OUT.mp4"
    return 1
  else
    ffmpeg -i "$1" -ss "$2" -to "$3" -async 1 "$4" && echo "Output to $4"
  fi
}

gif2mp4(){
  if [[ $# -ne 2 ]]; then
    echo "Usage: gif2mp4 INPUT.gif OUTPUT.mp4" >&2
    return 1
  fi

  local gif=$1
  local output_mp4=$2
  ffmpeg \
    -i "$gif" \
    -movflags faststart \
    -pix_fmt yuv420p \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    "$output_mp4"
}

unopened(){
  if [[ $# == 0 ]]; then
    search_spotlight_files \
      "(kMDItemLastUsedDate != '*') && (kMDItemContentType != 'public.folder')"
  else
    search_spotlight_files \
      "(kMDItemLastUsedDate != '*') && (kMDItemContentType != 'public.folder')" |
      head -n "$1"
  fi
}

opened(){
  search_spotlight_files \
    "(kMDItemLastUsedDate == '*') && (kMDItemContentType != 'public.folder')"
}

# Search for files in current directory
# Breaks (shows zero results no matter what) if the current directory is
# excluded in Spotlight privacy preferences, because this function relies on
# `mdfind`.
search_spotlight_files(){
  # `-onlyin .` will recurse
  mdfind -onlyin . "$1" | sort | rg -v '\.(part|ytdl|download)$'
}
words=/usr/share/dict/words
# }}}

# Options {{{
HISTFILE=~/.zsh_history
HISTSIZE=1000000000000000000
SAVEHIST=$HISTSIZE
setopt no_list_beep
setopt no_beep
# Append as you type (incrementally) instead of on shell exit
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt autocd
setopt autopushd
# Timestamp history entries
setopt extended_history
# Case-insensitive globbing
setopt nocaseglob
setopt extended_glob
setopt print_exit_value

unsetopt correctall
# Allow [ or ] wherever you want
# (Prevents "zsh: no matches found: ...")
unsetopt nomatch

# https://github.com/gabebw/dotfiles/pull/15
unsetopt multios

# i - Vim's smart case
# j.5 - Center search results
# n - Don't use line numbers, which makes less run more slowly on very large (eg log) files
# F - Quit if the content is <1 screen
# K - Quit on CTRL-C
# M - Longer prompt
# R - handle ASCII color escapes
# X - Don't send clear screen signal
export LESS="ij.5nFKMRX"

# Make Zsh's builtin `time` print output like `time` in Bash and every other
# system.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Note that these FZF options are used by fzf.vim automatically! Yay!
# Use a separate tool to smartly ignore files
export FZF_DEFAULT_COMMAND='rg --hidden --files --ignore-file ~/.ignore'
# Jellybeans theme: https://github.com/junegunn/fzf/wiki/Color-schemes
export FZF_DEFAULT_OPTS='--color fg:188,bg:233,hl:103,fg+:222,bg+:234,hl+:104
--color info:183,prompt:110,spinner:107,pointer:167,marker:215
--bind ctrl-u:page-up,ctrl-f:page-down
--reverse
'
# }}}

# Completion {{{
# http://zsh.sourceforge.net/Doc/Release/Completion-System.html
# zmodload -i zsh/complist
fpath=(
  ~/.zsh/completion-scripts
  /usr/local/share/zsh/site-functions
  /usr/local/opt/heroku/libexec/node_modules/@heroku-cli/plugin-autocomplete/autocomplete/zsh
  $fpath
)
autoload -Uz compinit
# completion: use cache if updated within 24h
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit -d $HOME/.zcompdump
else
  # Without redirecting output, it prints a lot of lines like this:
  #   "^A\"-\"^C\" self-inser" undefined-key
  #   "^D\" list-choice" undefined-key
  #   "^E\"-\"^F\" self-inser" undefined-key
  compinit -C >/dev/null
fi

# Try to match as-is then match case-insensitively
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Automatically recognize and complete commands that have been installed since
# the last time the zshrc was sourced.
# https://wiki.voidlinux.eu/Zsh#Persistent_rehash
zstyle ':completion:*' rehash true

# When you paste a <Tab>, don't try to auto-complete
zstyle ':completion:*' insert-tab pending

# Show a menu (with arrow keys) to select the process to kill.
# To filter, type `kill vi<TAB>` and it will select only processes whose name
# contains the substring `vi`.
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# When doing `cd ../<TAB>`, don't offer the current directory as an option.
# For example, if you're in foo, then `cd ../f` won't show `cd ../foo` as an
# option.
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Colorful lists of possible autocompletions for `ls`
# zstyle doesn't understand the BSD-style $LSCOLORS at all, so use Linux-style
# $LS_COLORS
zstyle ':completion:*:ls:*:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# Complete the command on the left like the command on the right
compdef '_files -/' tcd
compdef viw=which
compdef find-location-of=which
compdef staging=heroku
compdef production=heroku

if [ -f /usr/local/etc/bash_completion.d/um-completion.sh ]; then
  autoload -Uz bashcompinit && bashcompinit
  . /usr/local/etc/bash_completion.d/um-completion.sh
fi

# Show dots when autocompleting, so that I know it's doing something when
# autocompletion takes a long time.
expand-or-complete-with-dots() {
  echo -n "..."
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
# ^I is the <Tab> key
bindkey "^I" expand-or-complete-with-dots
# }}}

# $PATH {{{

# Add Homebrew to the path.
# Must be _before_ asdf so that /usr/local/bin/ruby isn't first in the $PATH.
PATH=/usr/local/bin:/usr/local/sbin:$PATH

# asdf version manager (ruby, node, etc)
# Load asdf early so that we can override it (e.g. by prepending `./bin/stubs`)
# later.
# I truly do not want to deal with the hassle of GPG, so don't fail to install
# when GPG isn't set up.
export NODEJS_CHECK_SIGNATURES=no
for f in /usr/local/opt/asdf/asdf.sh /usr/local/etc/bash_completion.d/asdf.bash; do
  [[ -r "$f" ]] && . "$f"
done

# Heroku standalone client
PATH="/usr/local/heroku/bin:$PATH"

# Node
PATH=$PATH:.git/safe/../../node_modules/.bin/

# Python
# Homebrew stores unversioned symlinks (e.g. `python` for `python3`) here, so
# add them to the front so we always get Python 3.
PATH=/usr/local/opt/python/libexec/bin:$PATH
PATH=/usr/local/Cellar/python/3.7.2_2/Frameworks/Python.framework/Versions/3.7/bin:$PATH

# Postgres.app
PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

PATH=$HOME/.bin:$PATH
PATH=./bin/stubs:$PATH

# Rust
[[ -r "$HOME"/.cargo/env ]] && source "$HOME"/.cargo/env

# }}}

# Key bindings {{{
# Vim-style line editing
# This sets up a bunch of bindings, so call this first and then call all
# other `bindkey`s after it to override anything you like.
bindkey -v

# Open current command in Vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^v" edit-command-line

# Fuzzy match against history, edit selected value
# For exact match, start the query with a single quote: 'curl
fuzzy-history() {
  selected=$(fc -l 1 | sed 's/^ *[0-9]* *//' | fzf --tac --reverse --no-sort)
  print -z "$selected"
}

# Ctrl-r triggers fuzzy history search
bindkey -M viins -s '^r' 'fuzzy-history\n'

# https://coderwall.com/p/jpj_6q
# Search through history for previous commands matching everything up to current
# cursor position. Move the cursor to the end of line after each match.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
# }}}

# cdpath {{{
has_subdirs(){
  if [[ -d "$1" ]]; then
    result=1
    for whatever in "$1"/*/; do
      result=0
      break
    done
    return $result
  else
    return 1
  fi
}

add_dir_to_cdpath(){
  if [ -d "$1" ]; then
    # Use lowercase `cdpath` because uppercase `CDPATH` can't be set to an array
    cdpath+=("$1")
  fi
}

add_subdirs_to_cdpath(){
  if has_subdirs "$1"; then
    for subdir in "$1"/*/; do
      cdpath+=("${subdir%/}")
    done
  fi
}

add_dir_to_cdpath "$HOME/code"
add_subdirs_to_cdpath "$HOME/code"
add_subdirs_to_cdpath "$HOME/code/work"

# Exporting $CDPATH is bad:
# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/
# So, export PROJECT_DIRECTORIES instead, but set it to $CDPATH
export PROJECT_DIRECTORIES=$CDPATH
# }}}

# Prompt {{{

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

# "2.5.1   (set by /Users/gabe/.tool-versions)" -> "2.5.1"
# "version 2.4.3 is not installed for ruby" -> "!!2.4.3 not installed"
# anything else -> don't change it
prompt_pretty_asdf_version(){
  local version=$(asdf current ruby 2>&1)
  case "$version" in
    *'set by'*) awk '{print $1}' <<<"$version";;
    *'not installed'*) sed 's/version (.+) is not installed.*/!!\1 not installed/' <<<"$version";;
    *) print "$version";;
  esac
}

prompt_ruby_version() {
  prompt_magenta "$(prompt_pretty_asdf_version)"
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
  if _not_in_tmux; then
    prompt_red '[!t] '
  fi
}

# }}}

# prompt_subst allows `$(function)` inside the PROMPT, which will be re-evaluated
# whenever the prompt is displayed. Don't put the PROMPT in double quotes, which
# will immediately evaluate the "$(code)".
setopt prompt_subst

PROMPT='$(prompt_tmux_status)$(prompt_ruby_version) $(prompt_shortened_path)$(prompt_git_email)$(prompt_full_git_status) $ '
# }}}

# Git {{{

# By itself: run `git status`
# With arguments: acts like `git`
function g {
  if [[ $1 == init ]]; then
    # This seems like a reasonable assumption: `git init directory-name`
    local directory=$2

    git "$@"

    # Use "main", not "master"
    pushd "$directory" >/dev/null
    if [[ "$(git current-branch)" == main ]]; then
      echo ">> You're on the main branch because init.defaultBranch worked"
      echo ">> Maybe delete the whole \$1 == init thing if it's always worked?"
    else
      echo "!! You're on $(git current-branch), not main" >&2
      echo "!! Fixing it for you now"
      git checkout -b main
      git branch -d master
    fi
    popd >/dev/null
  elif [[ $# > 0 ]]; then
    git "$@"
  else
    git st
  fi
}

alias gd="git diff"
alias gdm="git master-to-main-wrapper diff %BRANCH%"
# Grep with grouped output like Ack
alias gg="git g"
alias amend="git commit --amend -Chead"
alias amend-new="git commit --amend"

alias ga="git add"
alias gai="git add --interactive"
alias gcp="git rev-parse HEAD | xargs echo -n | pbcopy"
gcr(){
  local branch=$(select-git-branch --all)
  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
  true
}
gc(){
  if [[ $# == 0 ]]; then
    local branch=$(select-git-branch)
    if [[ -n "$branch" ]]; then
      git checkout "$branch"
    fi
    true
  else
    git checkout "$@"
  fi
}
gcm(){
  local commit_message=$@
  local branch=$(git current-branch )
  if [[ "$branch" =~ '^EXT-' ]]; then
    # Grab JIRA ticket name and prefix it to the commit
    ticket_number=$(echo "$branch" | sed -E 's/^(EXT-[0-9]+).*/\1/g')
    commit_message="$ticket_number $commit_message"
  fi
  local commit_message_length=$(echo -n "$commit_message" | wc -c | xargs echo -n)
  if [[ "$commit_message_length" -gt 50 ]]; then
    echo "Commit message length ($commit_message_length) > 50, not committing" >&2
    return 1
  else
    git commit -m "$commit_message"
  fi
}

# Check out a Git branch
function gb(){
  if [[ -z "$1" ]]; then
    echo "No branch name :(" >&2
    return 1
  fi
  local branch="$1"
  local base=$2
  if [[ -n "$base" ]]; then
    git checkout -b "$branch" "$base"
  else
    git checkout -b "$branch"
  fi
}
function gbm(){
  git master-to-main-wrapper checkout -b "$1" "origin/%BRANCH%"
}
git-branch-with-prefix(){
  if [[ $# == 0 ]]; then
    echo "No branch name :(" >&2
    return 1
  else
    gbm "${*// /-}"
  fi
}
hbc(){
  if [[ $# -ge 1 ]]; then
    hub browse -- commit/"$1"
  else
    local branch=$(git-shalector)
    if [[ -n "$branch" ]]; then
      hub browse -- commit/"$branch"
    fi
  fi
}
join-with(){ paste -sd "$1" - }
# Sum numbers (1 per line) from STDIN
sum(){ join-with "+" | bc }

function gcl {
  # if you do `local directory=$(superclone "$@")`, it will not pick up the
  # `superclone` return code and $? will always be 0 because it successfully
  # assigned the variable. The solution is to separate `local` onto its own
  # line.
  local directory
  directory=$(superclone "$@")
  if [[ $? -eq 0 ]]; then
    cd "$directory"
  else
    return 1
  fi
}

function gcl-fuzzy {
  local user=${1?}
  shift
  local repo=$(recent-repos-owned-by "$user" | fzf)
  local directory="$(superclone "$@" "$repo")"
  cd "$directory"
}

new-project(){
  printf "Project name? "
  read project_name
  local project_name=${project_name// /-}
  pushd personal >/dev/null
  if [[ -d "$project_name" ]]; then
    echo "!! Project directory with that name already exists" >&2
    return 1
  fi
  if [[ -f "$project_name" ]]; then
    echo "!! Project FILE with that name already exists" >&2
    return 1
  fi
  mkdir "$project_name" && tcd "./$project_name"
  popd >/dev/null
}

# Clone and start a new tmux session about it
clone(){
  if [[ $# < 2 ]]; then
    echo "Please provide a directory and a repo name" >&2
    echo "Usage: clone personal gabebw/dotfiles [gabebw-dotfiles]" >&2
    return 1
  fi
  local directory=$1
  local session_name
  pushd "$directory" >/dev/null
  shift
  if gcl "$@"; then
    # Name the session after the current directory
    session_name=$(basename "$PWD")
    if tmux-session-exists "$session_name"; then
      session_name="${session_name}-new"
    fi
    tcd "$PWD" "$session_name"
    popd >/dev/null
  fi
  popd >/dev/null
}

# Complete `g` like `git`, etc
compdef g=git
compdef _git gc=git-branch
compdef _git ga=git-add
# }}}

# Editor {{{
# Why set $VISUAL instead of $EDITOR?
# http://robots.thoughtbot.com/visual-ize-the-future
export VISUAL=vim
export EDITOR=$VISUAL
alias vi="$VISUAL"
alias ev="vim '$(readlink ~/.vimrc)'"
v(){
  local old_IFS=$IFS
  IFS=$'\n'
  local files=($(fzf-tmux --query="$1" --multi --exit-0))
  [[ -n "$files" ]] && $VISUAL "${files[@]}"
  IFS=$old_IFS
}
# "vim recent", a quick and dirty version of https://github.com/rupa/v
vr(){
  local file=$(awk '/^>/ { sub(/^> /, "") ; print }' ~/.viminfo | fzf)
  vim "${file/\~/$HOME}"
}

# Grep immediately on opening vim
gv(){
  if [[ $# != 1 ]]; then
    echo "Usage: gv THING_TO_GREP_FOR" >&2
    return 64
  else
    vim -c ":Grep $@"
  fi
}

# Remove vim flags for crontab -e
alias crontab="VISUAL=vim crontab"
# }}}

# Go {{{
export GOPATH=$HOME/.go
PATH=$PATH:$GOPATH/bin
# }}}

# Python {{{
export PYTHONSTARTUP=~/.pythonstartup

# Tell Virtualenv to store its data in ~/.virtualenvs
if [ -x /usr/local/bin/virtualenvwrapper.sh ]; then
  export VIRTUALENVWRAPPER_PYTHON=`which python2`
  export WORKON_HOME=~/.virtualenvs

  mkvirtualenv(){
    source /usr/local/bin/virtualenvwrapper.sh
    mkvirtualenv "$@"
  }

  workon(){
    source /usr/local/bin/virtualenvwrapper.sh
    workon "$@"
  }
fi
# }}}

# Ruby/Rails {{{

alias h=heroku
alias hsso="heroku login --sso"
alias migrate="be rake db:migrate db:test:prepare"
alias rollback="be rake db:rollback"
alias remigrate="migrate && rake db:rollback && migrate"
alias rrg="be rake routes | rg"
alias db-reset="be rake db:drop db:create db:migrate db:test:prepare"
alias unfuck-gemfile="git checkout HEAD -- Gemfile.lock"

# Bundler
alias be="bundle exec"

alias tagit='/usr/local/bin/ctags -R'

b(){
  if [[ $# == 0 ]]; then
    (bundle check > /dev/null || bundle install --jobs=4) && \
      bundle --quiet --binstubs=./bin/stubs
  else
    bundle "$@"
  fi
}

# Serve the current directory at localhost:8000
serveit(){
  ruby -run -ehttpd . -p8000
}

# }}}

# JavaScript {{{
cra(){
  local projectname=$1
  local do_prompt
  if yarn create react-app --template typescript "$@"; then
    pushd "$projectname"
    # Save old value
    [[ -e "$(setopt | rg rmstar)" ]] && do_prompt=true || do_prompt=false
    # Turn off Zsh prompt:
    # zsh: sure you want to delete all 8 files in DIR [yn]?
    setopt rm_star_silent
    rm -f src/*
    touch src/index.tsx
    # Turn the prompt back on, if it was disabled
    $do_prompt && unsetopt rm_star_silent
    git commit -am 'Remove autogenerated code'
    popd
    tcd "$projectname"
  fi
}
alias yarn="command yarn --ignore-engines"
# }}}

# Postgres {{{
# Set filetype on editing. Use `\e` to open the editor from `psql`.
export PSQL_EDITOR="vim -c ':set ft=sql'"

# db-dump DB_NAME FILENAME
function db-dump() {
  if (( $# == 2 )); then
    pg_dump --clean --create --format=custom --file "$2" "$1" && \
      echo "Wrote to $2"
  else
    echo "Usage: db-dump DB_NAME FILENAME"
    return 1
  fi
}

# db-restore DB_NAME FILENAME
function db-restore() {
  if (( $# == 2 )); then
    dropdb "$1" && \
      createdb "$1" && \
      pg_restore \
        --verbose \
        --clean \
        --no-acl \
        --no-owner \
        --jobs $(getconf _NPROCESSORS_ONLN) \
        --dbname "$1" \
        "$2"
  else
    echo "Usage: db-restore DB_NAME FILENAME"
    return 1
  fi
}
# }}}

# Homebrew {{{
# Opt out of sending Homebrew information to Google Analytics
# https://docs.brew.sh/Analytics
export HOMEBREW_NO_ANALYTICS=1
# If it's been more than this number of seconds since Homebrew was last
# updated, automatically run `brew update` before `brew install`.
# 604800 is 1 week in seconds (60 * 60 * 24 * 7).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Always cleanup after installing or upgrading
export HOMEBREW_INSTALL_CLEANUP=1
# }}}

# tmuxinator {{{
source ~/.zsh/completion-scripts/_tmuxinator
compdef _tmuxinator tmuxinator mux
alias mux=tmuxinator
# }}}

# custom TIL script, with completion {{{
TIL_DIRECTORY="/Users/gabe/code/personal/today-i-learned/"
_complete-first-file-argument() {
  if (( CURRENT == 2 )); then
    # Only complete first argument
    _files -W "$TIL_DIRECTORY"
  fi
}
# Usage: til how to do something -> open up Markdown file with that name
til(){
  local filename=$*
  filename=${filename// /-}
  mkdir -p "$(basename "${TIL_DIRECTORY}/${filename}")"
  echo "# $*\n" > "${TIL_DIRECTORY}/${filename}.md"
  vim "${TIL_DIRECTORY}/${filename}.md"
  echo "Don't forget to commit your file!"
}
compdef _complete-first-file-argument til
# }}}

# Set up SSH helper (mostly for Git)
ssh-add -K ~/.ssh/id_rsa 2> /dev/null

# zsh-syntax-highlighting must be sourced after all custom widgets have been
# created (i.e., after all zle -N calls and after running compinit), because it
# has to know about them to highlight them.
# More on ZSH_HIGHLIGHT_HIGHLIGHTERS:
# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -r ~/.aliases ]] && source ~/.aliases
