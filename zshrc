# Order does matter to an extent:
#  - editor must come before alias
#  - you probably want env to be first
#  - greeting should be last, just because
#  - greeting takes a while (relatively), because it outputs text
core_files=(env colors editor 'alias' path options completion git prompt) #greeting)
# order doesn't matter for extra_files
extra_files=(ruby rails rvm git homebrew)

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

  # recompile (creates compiled file if it doesn't exist, and updates
  # compiled file if needed)
  autoload -U zrecompile && zrecompile -p -R $all
  print "done with all."
}

# Make it if it doesn't exist
[[ ! -f $all ]] && compile_all

. $all

trim_path

function precmd {
  vcs_info 'prompt'
}

# Houston, we have liftoff.
