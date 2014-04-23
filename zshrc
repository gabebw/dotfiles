BASE="$HOME/.dotfiles/zsh"

CORE=(
  completion
  key_bindings
  # "tmux" needs to be before "navigation" because of current-tmux-session
  tmux
  navigation
  colors
  editor
  aliases
  path
  fasd
  options
  vcs
  prompt
  ruby
  rbenv
)

############################
#         EXTRAS           #
# (non-core functionality) #
############################
EXTRA=(
  git
  rails
  hitch
  postgres
  haskell
  go
  # arduino
)

source $BASE/tmux.zsh
attach_to_tmux

for core in $CORE
do
  source $BASE/$core.zsh
done

for extra in $EXTRA
do
  source $BASE/$extra.zsh
done

source $BASE/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH

# Houston, we have liftoff.
