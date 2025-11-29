if not status --is-interactive
  # Problem: Scripts are slow because my configuration in this file is slow.
  # Solution: Skip the configuration if not running interactively.
  #
  # Unlike files like `~/.bashrc` (which runs only for interactive shells)
  # `config.fish` is run for *every* fish shell, including non-interactive
  # shells. This was surprising to me.
  #
  # By skipping it, I speed up things like:
  #
  # * scripts that run with `#!/usr/bin/env fish`
  # * fzf, surprisingly: $FZF_DEFAULT_COMMAND is run with $SHELL, approximately
  #   equivalent to doing `fish -c $FZF_DEFAULT_COMMAND`
  #
  # As a rough benchmark, skipping my configuration saves ~130ms on `fzf`
  # initialization.
  if not set -q I_REALLY_WANT_TO_RUN_FISH_CONFIG_FOR_FIND_LOCATION_OF
    # This escape hatch means that things below can run in a non-interactive
    # shell, so there are more checks below for `status --is-interactive`.
    return 0
  end
end

# tmux {{{
function inside_ssh
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
end

function in_vs_code
  [ "$TERM_PROGRAM" = "vscode" ]
end

function in_ghostty_quick_terminal
  [ $(tput lines) -le 25 ]
end

if not inside_ssh; and not in_vs_code; and status --is-interactive; and not in_ghostty_quick_terminal
  # Connect to most recent tmux session

  if not set -q TMUX; and tmux has-session 2>/dev/null
    # We're not in tmux now, but a tmux session exists

    # Get the name of the most recent tmux session, sorted by time the session
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
# }}}

# Aliases {{{
alias va "nvim ~/.aliases.fish"
alias q "nvim (readlink ~/.config/fish/config.fish)"
alias qq "source ~/.config/fish/config.fish"
alias cp "cp -iv"
alias rm "rm -Iv"
alias mv "mv -iv"
alias ls "ls -FGh"
alias du "du -cksh"
alias df "df -h"
# Use modern regexps for sed, i.e. "(one|two)", not "\(one\|two\)"
alias sed "sed -E"

alias dup "pushd dotfiles; and git checkout main &>/dev/null; and git pull; and git checkout - &>/dev/null; and popd; and qq"

# Remove fish's alias, which breaks completions when I add another one
functions -e diff
function diff -w diff
  command diff --color=auto -U3 $argv
end

# It can be used anywhere, not just in git
alias diff-long-lines "git diff --word-diff=porcelain"
alias mkdir "command mkdir -p"
function serialnumber
  ioreg -l | rg IOPlatformSerialNumber | sed -e 's/^.*= "(.+)"/\1/' | tee /dev/tty | pbcopy
  echo '(Copied for you)'
end

function prettyjson
  if isatty stdin
    pbcopy | prettyjson | pbpaste
  else
    jq .
  end
end

function prettyxml
  if isatty stdin
    pbpaste | prettyxml | pbcopy
  else
    # xmllint is from `brew install libxml2`
    xmllint --format -
  end
end

function prettyhtml
  if isatty stdin
    pbpaste | prettyhtml | pbcopy
  else
    prettier --stdin-filepath any-name-here.html
  end
end

function prettyjavascript
  if isatty stdin
    pbpaste | prettyjavascript | pbcopy
  else
    prettier --stdin-filepath any-name-here.js
  end
end

# Remove EXIF data
alias exif-remove "exiftool -all  "
alias hexdump hexyl

# All the flags I always want turned on
alias fd-basic "command fd --no-ignore --ignore-case --full-path --type file"

alias fd "fd-basic --type file"

[ -r ~/.rgrc ] && set -x RIPGREP_CONFIG_PATH ~/.rgrc
# Note that `bat` does not understand `~`, so we need `$HOME`
set -x BAT_CONFIG_PATH "$HOME/.config/bat/config"
alias cat bat
alias less bat
abbr -a -- - 'cd -'
alias dotfiles 'cd dotfiles'

# Slice out a piece of a string using a regex.
# For example:
#   $ slice 'sd[fg]' 'asdf'
#   sdf
function slice -a pattern s
  string match -r $pattern $s
end

function dig-all -a url
  if not string match -qre '^www\.' $url
    printf "!! Note that CNAME cannot be on the bare domain\n\n" >&1
  end

  # Add a period to the end to canonicalize it, otherwise many records don't
  # show up with the +norecurse flag
  if not string match -qre '\.$' $url
    set -f url "$url."
  end

  for record in a aaaa cname mx ns txt
    # +noall: Turn off all output
    # +answer: Show just the answer
    dig +noall +answer $record $url
  end

  # Fastmail-specific email stuff
  # https://www.fastmail.help/hc/en-us/articles/1500000280261-Setting-up-your-domain-MX-only#domain-registration
  for fm in fm1 fm2 fm3
    dig +noall +answer CNAME $fm._domainkey.$url
  end
  dig +noall +answer TXT _dmarc.$url
end

# Show a Notification Center notification. Good for long-running tasks:
# long_running_task && notifyme "All done"
function notifyme
  set -l words (string join " " $argv)
  osascript -e "display notification \"$words\" with title \"Title\""
end
# }}}

# Options {{{

# Note that these FZF options are used by fzf.vim automatically! Yay!
# Use a separate tool to smartly ignore files
set -x FZF_DEFAULT_COMMAND 'rg --hidden --files --ignore-file ~/.ignore'
set -x FZF_DEFAULT_OPTS_FILE $HOME/.fzfrc # Doesn't expand ~, so use $HOME
# }}}

# Completion {{{
if status --is-interactive
  complete -c tcd --no-files -a "(__fish_complete_directories)"

  # Ensure we never limit to 1 file (the conditions accrete)
  complete -c t --no-files
  # Complete exactly 1 argument (drawn from tmux session names)
  # The special printing format is `#{?condition,IF_TRUE,IF_FALSE}`.
  # So we only print the session name if it's not the current attached session.
  # This prints an empty new line for the current session, which fish
  # automatically ignores.
  complete -c t -a "(tmux ls -F '#{?session_attached,,#{session_name}}' 2>/dev/null)" --condition "__fish_is_first_arg" --condition "tmux has-session 2>/dev/null"

  complete -c viw -w which
  complete -c find-location-of -w which
  complete -c fly -w flyctl

  # Complete `staging` like the `heroku` command
  complete -c staging -w heroku
  # Add a `deploy` subcommand, while keeping the standard Heroku completions
  complete -c staging -n __fish_use_subcommand -a deploy -d "Deploy to staging"

  # Complete `production` like the `heroku` command
  complete -c production -w heroku
  # Add a `deploy` subcommand, while keeping the standard Heroku completions
  complete -c production -n __fish_use_subcommand -a deploy -d "Deploy to production"

  for script in ~/.config/fish/completions/*.fish
    source $script
  end
end
# }}}

# Key bindings {{{
# Vim-style line editing
if status --is-interactive
  fish_vi_key_bindings
  set fish_cursor_default block
  set fish_cursor_replace_one underscore
  set fish_cursor_visual block blink
end
# Fuzzy match against history, edit selected value
# For exact match, start the query with a single quote: 'curl
function fuzzy-history
  test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
  set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"
  # Copied from `fzf-history-widget`:
  # https://github.com/junegunn/fzf/blob/master/shell/key-bindings.fish
  # `-z` uses null bytes to terminate lines so we can find multi-line commands.
  history -z | fzf --read0 --print0 -q (commandline) | read -lz result
  and commandline -- $result
  commandline -f repaint
end

# Use Alfred's database of clipboard history and run it through FZF
function fuzzy-clipboard-history
  set -l clipboard_db "$HOME/Library/Application Support/Alfred/Databases/clipboard.alfdb"
  set -l column_name "item"
  set -l query (string join ' ' 'SELECT replace(item, CHAR(10), "") as ' $column_name ' FROM clipboard ORDER BY ts DESC;')
  sqlite3 -line -noheader "$clipboard_db" $query 2>/dev/null | \
    sed -n -e "s/$column_name = //p" | \
    fzf --no-sort --multi
end

if status --is-interactive
  # Ctrl-r triggers fuzzy history search
  bind -M insert \cr 'fuzzy-history'
  # Ctrl-v opens command line in your editor
  bind -M insert \cv edit_command_buffer
  # Ctrl-p shows clipboard history in FZF and copies the selected item
  bind -M insert \cp 'fuzzy-clipboard-history'
end
# }}}

# cdpath {{{
if status --is-interactive
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
  # Prepend `.` so that directories in the current dir are tried first
  set -g --prepend CDPATH .
end
# }}}

# Prompt {{{
if status --is-interactive
  starship init fish | source
end
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
set -x VISUAL nvim
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
function db-dump-and-restore -a connection_string local_db_name
  if [ (count $argv) -ne 2 ]
    echo "Usage: db-dump-and-restore <connection string> <local_db_name>" >&2
    return 1
  end
  dropdb $local_db_name; or return 1
  set -f dumpfile (mktemp)
  db-dump $connection_string $dumpfile
  and db-restore $local_db_name $dumpfile
  # Use `command` to bypass my alias so it's quiet and not verbose
  command rm $dumpfile
end
alias unfuck-gemfile "git checkout HEAD -- Gemfile.lock"

# Bundler
alias be "bundle exec"
alias tagit 'ctags -R'

# Ruby by default looks for openssl@1.1, which doesn't exist
set -x RUBY_CONFIGURE_OPTS "--with-openssl-dir="$(brew --prefix openssl@3)
# }}}

# Postgres {{{
# Set filetype on editing. Use `\e` to open the editor from `psql`.
set -x PSQL_EDITOR "nvim -c ':set ft=sql'"
# }}}

# Homebrew {{{
# Opt out of sending Homebrew information to Google Analytics
# https://docs.brew.sh/Analytics
set -x HOMEBREW_NO_ANALYTICS 1
# Do not auto-update Homebrew.
set -x HOMEBREW_NO_AUTO_UPDATE 1
# Always cleanup after installing or upgrading
set -x HOMEBREW_INSTALL_CLEANUP 1
# }}}

# Set up SSH helper (mostly for Git)
if status --is-interactive
  ssh-add -K ~/.ssh/id_rsa 2> /dev/null
end
# The `$TERM` might be `xterm-ghostty`, which is non-standard and makes various CLI
# commands on Digital Ocean think they're in an unsupported terminal.
# The `SetEnv` option (e.g. `-o 'SetEnv TERM=xterm-256color'` or adding it to
# `~/.ssh/config`) only works on OpenSSH >= 8.7, which is not built in on macOS.
# So we'll just do this for now.
alias ssh "TERM=xterm-256color command ssh"

# $PATH {{{
# $PATH stuff is last so that other things don't add their own $PATH stuff
# before it.
# Note that `fish_add_path` will prepend by default.
# It is also universal by default, unless you pass "--path".

# Add Homebrew to the path.
set HOMEBREW_PREFIX (brew --prefix)
fish_add_path --move --path $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin

# Find Node commands from current project
set PATH $PATH ".git/safe/../../node_modules/.bin/"

# Postgres.app takes precedence
fish_add_path --move --path /Applications/Postgres.app/Contents/Versions/latest/bin

fish_add_path --path --move $HOME/.bin

# Rust
[ -d "$HOME/.cargo/bin" ] && fish_add_path --move --path $HOME/.cargo/bin

# Scala/Java
# https://get-coursier.io/docs/cli-installation
fish_add_path --move --path --append $HOME"/Library/Application Support/Coursier/bin"

status --is-interactive; and mise activate | source

# Prepend binstubs
# Do not use `fish_add_path` because that will expand `.` to wherever you are
# when you sourced `config.fish`. I want it to refer to the current directory
# wherever I am.
set PATH ./bin/stubs $PATH

# Tell well-behaved tools to look in ~/.config for dotfiles
set -x XDG_CONFIG_HOME "$HOME/.config"

# Go
# `go install` will install executables to ~/.bin
set -x GOBIN ~/.bin
# }}}

[ -r ~/.aliases.fish ] && source ~/.aliases.fish

if status --is-interactive
  set -U fish_greeting ""
  # Erase a global (non-universal) variable if set, since it interferes with the
  # universal one.
  set --erase fish_features
  # ampersand-nobg-in-token: `&` is no longer interpreted as the backgrounding
  #   operator in the middle of a token, so dealing with URLs becomes easier.
  # qmark-noglob: `?` is no longer interpreted as a glob operator in the middle
  #   of a token, so dealing with URLs becomes easier.
  set -U fish_features stderr-nocaret ampersand-nobg-in-token qmark-noglob

  # Colorscheme: Dracula
  set -U fish_color_normal normal
  set -U fish_color_command F8F8F2
  set -U fish_color_quote F1FA8C
  set -U fish_color_redirection 8BE9FD
  set -U fish_color_end 50FA7B
  set -U fish_color_error FFB86C
  set -U fish_color_param FF79C6
  set -U fish_color_comment 6272A4
  set -U fish_color_match --background=brblue
  set -U fish_color_selection white --bold --background=brblack
  set -U fish_color_search_match bryellow --background=brblack
  set -U fish_color_history_current --bold
  set -U fish_color_operator 00a6b2
  set -U fish_color_escape 00a6b2
  set -U fish_color_cwd green
  set -U fish_color_cwd_root red
  set -U fish_color_valid_path --underline
  set -U fish_color_autosuggestion BD93F9
  set -U fish_color_user brgreen
  set -U fish_color_host normal
  set -U fish_color_cancel --reverse
  set -U fish_pager_color_prefix normal --bold --underline
  set -U fish_pager_color_progress brwhite --background=cyan
  set -U fish_pager_color_completion normal
  set -U fish_pager_color_description B3A06D
  set -U fish_pager_color_selected_background --background=brblack

  function fish_greeting
    set -f this_file (readlink (status --current-filename))
    # -C <path>: Run as if git was started in <path> instead of the current working directory
    set -f dotfiles_git_dir (git -C (dirname $this_file) rev-parse --show-toplevel)
    # Fortune doesn't like `~/.habits`, so point it directly here
    fortune $dotfiles_git_dir/habits | simple_format
  end
end
