BASE="$HOME/.dotfiles/zsh"

# First, ensure we're in tmux
source $BASE/tmux.zsh
attach_to_tmux

CORE=(
  completion
  key_bindings
  navigation
  colors
  editor
  aliases
  path
  fasd
  options
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
)

for core in $CORE
do
  source $BASE/$core.zsh
done

for extra in $EXTRA
do
  source $BASE/$extra.zsh
done

# brew install zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH

# Houston, we have liftoff.
