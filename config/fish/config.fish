# tmux {{{
function connect_to_most_recent_tmux_session
  # Not in tmux now, but a tmux session exists
  if not set -q TMUX; and tmux has-session 2>/dev/null
    # the name of the most recent tmux session, sorted by time the session
    # was last attached.
    set -f most_recent_tmux_session (
      tmux list-sessions -F "#{session_last_attached} #{session_name}" | \
        sort -r | \
        cut -d' ' -f2 | \
        head -1
    )
    tmux attach -t $most_recent_tmux_session
  end
end

function inside_ssh
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
end

function in_vs_code
  [ "$TERM_PROGRAM" = "vscode" ]
end

if not inside_ssh; and not in_vs_code
  connect_to_most_recent_tmux_session
end
# }}}

# Aliases {{{
alias va "vim ~/.aliases.fish"
alias q "vim (readlink ~/.config/fish/config.fish)"
alias qq "source ~/.config/fish/config.fish"
alias cp "cp -iv"
alias rm "rm -iv"
alias mv "mv -iv"
alias ls "ls -FGh"
alias du "du -cksh"
alias df "df -h"
# Use modern regexps for sed, i.e. "(one|two)", not "\(one\|two\)"
alias sed "sed -E"

alias dup "pushd dotfiles; and git checkout main &>/dev/null; and git pull; and git checkout - &>/dev/null; and popd; and qq"
alias diff "command diff --color auto -u"
alias mkdir "command mkdir -p"
alias serialnumber "ioreg -l | rg IOPlatformSerialNumber | cut -d  -f2 | sed 's/[ \"]//g' | tee /dev/tty | pbcopy; echo '(Copied for you)'"
alias prettyjson "jq ."
# xmllint is from `brew install libxml2`
alias prettyxml "xmllint --format -"
alias prettyjavascript "prettier --stdin-filepath any-name-here.js"
# Remove EXIF data
alias exif-remove "exiftool -all  "
alias hexdump hexyl

alias fd 'command fd --no-ignore --ignore-case --full-path --type file'
[ -r ~/.rgrc ] && set -x RIPGREP_CONFIG_PATH ~/.rgrc
set -x BAT_CONFIG_PATH "~/.config/bat/config"
alias cat bat
alias less bat
abbr -a -- - 'cd -'
# }}}

# Options {{{

# Note that these FZF options are used by fzf.vim automatically! Yay!
# Use a separate tool to smartly ignore files
set -x FZF_DEFAULT_COMMAND 'rg --hidden --files --ignore-file ~/.ignore'
# Jellybeans theme: https://github.com/junegunn/fzf/wiki/Color-schemes
set -x FZF_DEFAULT_OPTS '--color fg:188,bg:233,hl:103,fg+:222,bg+:234,hl+:104
--color info:183,prompt:110,spinner:107,pointer:167,marker:215
--bind ctrl-u:page-up,ctrl-f:page-down
--reverse
'
# }}}

# Completion {{{
complete -c tcd -f -a "(__fish_complete_directories)"
complete -c viw -w which
complete -c find-location-of -w which
complete -c staging -w heroku
complete -c production -w heroku

for script in ~/.config/fish/completions/*.fish
  source $script
end
# }}}

# Key bindings {{{
# Vim-style line editing
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_replace_one underscore
set fish_cursor_visual block blink
# }}}

# cdpath {{{
function add_dir_to_cdpath -a directory
  if [ -d "$directory" ]
    set -g CDPATH $CDPATH $directory
  end
end

function add_subdirs_to_cdpath -a directory
  for subdir in $directory/*/
    set -g CDPATH $CDPATH (string replace -r '/$' '' $subdir)
  end
end

add_dir_to_cdpath $HOME/code
add_subdirs_to_cdpath $HOME/code
add_subdirs_to_cdpath $HOME/code/work

# Exporting $CDPATH is bad:
# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/
# So, export PROJECT_DIRECTORIES instead, but set it to $CDPATH
set -x PROJECT_DIRECTORIES $CDPATH
# }}}

# Prompt {{{
starship init fish | source
# }}}

# Git {{{
alias gd "git diff"
alias gdm "git master-to-main-wrapper diff origin/%BRANCH%"
alias amend "git commit --amend -Chead"
alias amend-new "git commit --amend"
alias ga "git add"
alias gcp "git rev-parse HEAD | xargs echo -n | pbcopy"
# }}}

# Editor {{{
# Why set $VISUAL instead of $EDITOR?
# http://robots.thoughtbot.com/visual-ize-the-future
set -x VISUAL vim
set -x EDITOR $VISUAL
alias vi $VISUAL
# }}}

# Ruby/Rails {{{

alias h heroku
alias migrate "be rake db:migrate db:test:prepare"
alias rollback "be rake db:rollback"
alias remigrate "migrate && rake db:rollback && migrate"
alias rrg "rails routes | rg"
alias db-reset "be rake db:drop db:create db:migrate db:test:prepare"
alias unfuck-gemfile "git checkout HEAD -- Gemfile.lock"

# Bundler
alias be "bundle exec"
alias tagit '/usr/local/bin/ctags -R'
# }}}

# Postgres {{{
# Set filetype on editing. Use `\e` to open the editor from `psql`.
set -x PSQL_EDITOR "vim -c ':set ft=sql'"
# }}}

# Homebrew {{{
# Opt out of sending Homebrew information to Google Analytics
# https://docs.brew.sh/Analytics
set -x HOMEBREW_NO_ANALYTICS 1
# If it's been more than this number of seconds since Homebrew was last
# updated, automatically run `brew update` before `brew install`.
# 604800 is 1 week in seconds (60 * 60 * 24 * 7).
set -x HOMEBREW_AUTO_UPDATE_SECS 604800

# Always cleanup after installing or upgrading
set -x HOMEBREW_INSTALL_CLEANUP 1
# }}}

# Set up SSH helper (mostly for Git)
ssh-add -K ~/.ssh/id_rsa 2> /dev/null

# $PATH {{{
# $PATH stuff is last so that other things don't add their own $PATH stuff
# before it.
# Note that `fish_add_path` will prepend by default.

# Add Homebrew to the path.
fish_add_path /usr/local/bin /usr/local/sbin

# Heroku standalone client
fish_add_path /usr/local/heroku/bin

# Node
fish_add_path --append ".git/safe/../../node_modules/.bin/"

# Postgres.app takes precedence
fish_add_path /Applications/Postgres.app/Contents/Versions/latest/bin

fish_add_path --move $HOME/.bin

# Rust
[ -d "$HOME/.cargo/bin" ] && fish_add_path $HOME/.cargo/bin

# rbenv
status --is-interactive; and rbenv init - fish | source

# Add binstubs *after* doing rbenv
fish_add_path ./bin/stubs

# Node
eval "$(fnm env --use-on-cd --log-level=error)"
# }}}

[ -r ~/.aliases.fish ] && source ~/.aliases.fish

set fish_greeting ""
