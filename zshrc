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
va(){ vim ~/.aliases }
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
  # Do *not* add a space in `Accept-Encoding:gzip` because then it prints the
  # entire body to the terminal instead of just `[866 bytes data]`.
  command curl \
    --disable \
    --verbose \
    --silent \
    --show-error \
    --output /dev/null \
    -H Fastly-debug:1 \
    -H Accept-Encoding:gzip \
    "$@" \
    2>&1
}
curl-with-javascript(){
  if command -v playwright &>/dev/null; then
    NODE_PATH="$(yarn global dir)/node_modules/" node ~/.bin/curl-with-javascript.js "$1"
  else
    npm install -g playwright
    curl-with-javascript "$@"
  fi
}
alias dup="pushd dotfiles && git checkout main &>/dev/null && git pull && git checkout - &>/dev/null && popd && qq"
alias ...="cd ../.."
# Copy-pasting `$ python something.py` works
alias \$=''
alias diff="command diff --color=auto -u"
alias mkdir="command mkdir -p"
alias serialnumber="ioreg -l | rg IOPlatformSerialNumber | cut -d= -f2 | sed 's/[ \"]//g' | tee /dev/tty | pbcopy; echo '(Copied for you)'"
alias prettyjson="jq ."
# xmllint is from `brew install libxml2`
alias prettyxml="xmllint --format -"
alias prettyjavascript="prettier --stdin-filepath=any-name-here.js"
# Remove EXIF data
alias exif-remove="exiftool -all= "
alias hexdump=hexyl
youtube-dl-safe(){
  # If there are any arguments, don't use xargs, because it's likely a one-off,
  # and spaces in argument values break xargs.
  local has_arguments=false
  for arg in "$@"; do
    if [[ "$arg" =~ "^-" ]]; then
      has_arguments=true
      break
    fi
  done

  if $has_arguments; then
    print "\n\n>>> Since there are custom arguments, I assume there's just one URL, so I'm not parallelizing\n\n"
    yt-dlp --no-check-certificates --ignore-errors --no-mtime --no-overwrites --prefer-ffmpeg --add-metadata --continue "$@"
  else
    echo "$@" | xargs -P 5 -n 1 yt-dlp --no-check-certificates --ignore-errors --no-mtime --no-overwrites --prefer-ffmpeg --add-metadata --continue
  fi
}

y(){
  # Expand `$(pbpaste)` to the real URL in scrollback
  echo "Downloading ${@:-"$(pbpaste)"}"
  youtube-dl-safe "${@:-"$(pbpaste)"}"
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
rcup(){
  if ! command rcup -fv | grep -v identical; then
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
xo1(){ null_terminate_filenames | xargs -n1 -o -0 "${@:-open}" }
# [xo] with an [a]pp
xoa(){ xo open -a "$1" }

alias htop="command htop --sort-key=PERCENT_CPU"
alias fd='command fd --no-ignore --ignore-case --full-path --type file'
alias xee="open -a Xee³"
if [[ -r ~/.rgrc ]]; then
  export RIPGREP_CONFIG_PATH=~/.rgrc
fi
export BAT_CONFIG_PATH="~/.config/bat/config"
alias cat=bat
alias less=bat

o(){
  custom_fd(){ command fd --no-ignore --type file "$@" }
  open_images_in_directory(){
      # `--depth 1` means "only go 1 level inside the directory and don't recurse"
      custom_fd \
        -e jpg -e png -e jpeg \
        --depth 1 \
        --base-directory "$1" \
        -X open -a Preview
  }

  if [[ -d "$1" ]]; then
    if command fd -e mp4 -e flv -e mov -q --base-directory "$1"; then
      # "-X <command>" means the results are concatenated and the command is
      # executed once with all found results.
      custom_fd \
        -e mp4 -e flv -e mov \
        --base-directory "$1" \
        -X open
    else
      open_images_in_directory "$1"
    fi
  else
    if [[ $# == 0 ]]; then
      # Are there any images in this directory?
      if [[ -n *.{png,jpg}(#qN) ]]; then
        open_images_in_directory .
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
  mdfind -onlyin . "$1" | sort | rg -v '\.(part|ytdl|download|epub)$'
}
# }}}

# Options {{{
HISTFILE=~/.zsh_history
HISTSIZE=1000000000000000000
SAVEHIST=$HISTSIZE
unsetopt list_beep
unsetopt beep
# Append as you type (incrementally) instead of on shell exit
setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt autocd
setopt autopushd
# Timestamp history entries
setopt extended_history
# Case-insensitive globbing
unsetopt caseglob
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

# Key bindings {{{
# Vim-style line editing
# This sets up a bunch of bindings, so call this first and then call all
# other `bindkey`s after it to override anything you like.
bindkey -v

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
eval "$(starship init zsh)"
# }}}

# Git {{{

# By itself: run `git status`
# With arguments: acts like `git`
function g {
  if [[ $# > 0 ]]; then
    git "$@"
  else
    git st
  fi
}

alias gd="git diff"
alias gdm="git master-to-main-wrapper diff origin/%BRANCH%"
alias amend="git commit --amend -Chead"
alias amend-new="git commit --amend"

alias ga="git add"
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

# With no arguments: "git checkout [main | master]"
# With arguments: "git commit" with the arguments as the message
gcm(){
  local commit_message=$@
  local branch=$(git current-branch )
  if [[ "$#" == 0 ]]; then
    git master-to-main-wrapper checkout %BRANCH%
  else
    # Grab JIRA ticket name (if any) and prefix it to the commit.
    if [[ "$branch" =~ '^([A-Z]{2,}-[0-9]+)' ]]; then
      # The magic "$match" array variable now contains the groups we matched
      # (1-indexed).
      ticket_number=$match[1]
      commit_message="$ticket_number $commit_message"
    fi
    local commit_message_length=$(echo -n "$commit_message" | wc -c | xargs echo -n)
    if [[ "$commit_message_length" -gt 50 ]]; then
      echo "Commit message length ($commit_message_length) > 50, not committing" >&2
      return 1
    else
      git commit -m "$commit_message"
    fi
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
# turn "a b c" into "a\nb\nc"
split-on-spaces(){ tr ' ' '\n' }
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

new-project(){
  if [[ $# == 0 ]]; then
    printf "Project name? "
    read project_name
  else
    project_name=$1
  fi
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
  if [[ "$PWD" == "$HOME" ]]; then
    echo "Refusing to run this in your home directory" >&2
    return 1
  fi
  local old_IFS=$IFS
  IFS=$'\n'
  local files=($(fzf-tmux --query="$1" --multi --exit-0))
  [[ -n "$files" ]] && $VISUAL "${files[@]}"
  IFS=$old_IFS
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

# Ruby/Rails {{{

alias h=heroku
alias migrate="be rake db:migrate db:test:prepare"
alias rollback="be rake db:rollback"
alias remigrate="migrate && rake db:rollback && migrate"
alias rrg="rails routes | rg"
alias db-reset="be rake db:drop db:create db:migrate db:test:prepare"
alias unfuck-gemfile="git checkout HEAD -- Gemfile.lock"

# Bundler
alias be="bundle exec"

alias tagit='/usr/local/bin/ctags -R'

b(){
  if [[ $# == 0 ]]; then
    (bundle check > /dev/null || bundle install --jobs=4) && \
      bundle binstubs --all --path=./bin/stubs
  else
    bundle "$@"
  fi
}

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

# custom TIL script, with completion {{{
TIL_DIRECTORY="/Users/gabe/code/personal/today-i-learned/"
_complete-first-file-argument() {
  if (( CURRENT == 2 )); then
    # Only complete first argument
    _files -W "$TIL_DIRECTORY"
  fi
}
til(){
  if [[ $# == 0 ]]; then
    echo "Usage: til how to do something"
    return 0;
  fi
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
if [[ -z "$ZSH_HIGHLIGHT_HIGHLIGHTERS" ]]; then
  # Only source Zsh Syntax Highlighting once, otherwise we can run into
  # a "maximum nested function level reached" error
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Run in dotfiles repo
sort-vscode-settings() {
  local f="./Library/Application Support/Code/User/settings.json"
  jq --sort-keys < "$f" | sponge "$f"
}

# $PATH {{{
# $PATH stuff is last so that other things don't add their own $PATH stuff
# before it.

# This prevents duplicate entries in $PATH (e.g. after re-sourcing this files).
typeset -U path

# Add Homebrew to the path.
PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Heroku standalone client
PATH="/usr/local/heroku/bin:$PATH"

# Node
PATH=$PATH:.git/safe/../../node_modules/.bin/

# Python
# Homebrew stores unversioned symlinks (e.g. `python` for `python3`) here, so
# add them to the front so we always get Python 3.
PATH=/usr/local/opt/python/libexec/bin:$PATH
PATH=/usr/local/Cellar/python/3.7.2_2/Frameworks/Python.framework/Versions/3.7/bin:$PATH

# Postgres.app takes precedence
PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH

PATH=$HOME/.bin:$PATH

# Rust
[[ -r "$HOME"/.cargo/env ]] && source "$HOME"/.cargo/env
alias ci="cargo install --path . --force"

# rbenv
eval "$(rbenv init -)"

# Add binstubs *after* doing rbenv
PATH=./bin/stubs:$PATH

# Node
eval "$(fnm env --use-on-cd --log-level=error)"
# }}}

[[ -r ~/.aliases ]] && source ~/.aliases
