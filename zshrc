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
# od -a -> named hexdump, i.e. "nul" instead of hexdump -C's "0"

# Order does matter to an extent:
#  - editor must come before alias
#  - you probably want env to be first
#  - greeting should be last, just because
#  - greeting takes a while (relatively), because it outputs text
core_files=(env colors editor 'alias' path options completion git prompt) #greeting)
# order doesn't matter for extra_files
extra_files=(ruby rails rvm python git android node-js homebrew)

all=~/.dotfiles/zsh-all.zsh

# Sourcing tens of files makes this take too long. So, just jam everything
# into one big file, zcompile it, and source that.
function compile_all {
  print "Compiling all..."
  echo -n > $all # clear it
  # put core and extras all in one big file
  # core should go before extras.
  for f in $core_files
  do
    cat ~/.dotfiles/zsh/$f >> $all
  done

  for f in $extra_files
  do
    cat ~/.dotfiles/extra/$f >> $all
  done

  zcompile $all # EXXXTREME PERFORMANCE (not really)
  print "done with all."
}

# Make it if it doesn't exist
[[ ! -f $all ]] && compile_all

. $all

function precmd {
  vcs_info 'prompt'
}

# Houston, we have liftoff.
