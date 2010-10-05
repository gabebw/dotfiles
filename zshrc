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

ZSH_CONFIG_PATH=~/.dotfiles/zsh
. $ZSH_CONFIG_PATH/env
echo -n "env | "
. $ZSH_CONFIG_PATH/editor # set it as early as possible so the vim alias is present
echo -n "editor | "
. $ZSH_CONFIG_PATH/alias  # gives {source,edit}_extra
echo -n "alias | "
. $ZSH_CONFIG_PATH/path
echo -n "path | "
. $ZSH_CONFIG_PATH/options
echo -n "options | "
. $ZSH_CONFIG_PATH/completion
echo -n "completion | "
. $ZSH_CONFIG_PATH/colors
echo -n "colors | "
. $ZSH_CONFIG_PATH/git
echo -n "git | "
. $ZSH_CONFIG_PATH/extras # before sourcing prompt
echo -n "extras | "
. $ZSH_CONFIG_PATH/prompt
echo -n "prompt"
echo # make way for greeting
. $ZSH_CONFIG_PATH/greeting

function precmd {
  vcs_info 'prompt'
}

# Houston, we have liftoff.
