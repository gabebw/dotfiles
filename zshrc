# This might help: http://dotfiles.org/.zshrc
# to change shell: chsh -s /bin/zsh
#
# Okay, useful stuff:
# fc: opens an editor (default vi) to edit the last command
#
# r: redoes last command with optional changes, e.g.
#   echo foo  # => "foo"
#   r foo=bar # => "bar"
# cal/ncal: gives you an ASCII calendar
# hashing: hash -d HASH=directory, then "cd ~HASH"
#   Do not use ~ in the directory, either. Use /Users/gabe/.
# http://michael-prokop.at/blog/2008/12/01/mikas-advent-calendar-day-1/
# Hey, "unfunction" is a thing. It's like unset, but for functions.

function progress {
  echo -n "$1 | "
}

ZSH_CONFIG_PATH=~/.dotfiles/zsh
. $ZSH_CONFIG_PATH/env        && progress "env"
. $ZSH_CONFIG_PATH/colors     && progress "colors"
# set editor as early as possible so the vim alias is present
. $ZSH_CONFIG_PATH/editor     && progress "editor"
# gives {source,edit}_extra
. $ZSH_CONFIG_PATH/alias      && progress "alias"
. $ZSH_CONFIG_PATH/path       && progress "path"
. $ZSH_CONFIG_PATH/options    && progress "options"
. $ZSH_CONFIG_PATH/completion && progress "completion"
. $ZSH_CONFIG_PATH/git        && progress "git"
# do extras before sourcing prompt
. $ZSH_CONFIG_PATH/extras     && progress "extras"
. $ZSH_CONFIG_PATH/prompt     && progress "prompt"
echo # make way for greeting
. $ZSH_CONFIG_PATH/greeting

function precmd {
  vcs_info 'prompt'
}

# Houston, we have liftoff.
