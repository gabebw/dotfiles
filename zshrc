BASE="$HOME/.dotfiles/zsh"

# First, ensure we're in tmux
source $BASE/tmux.zsh
ensure_we_are_inside_tmux

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
  git
  rails
  hitch
  postgres
  haskell
  python
  go
  docker
)

for file in $CORE
do
  source "$BASE/$file.zsh"
done

# brew install zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH
current

echo "Remember to use j"

# Houston, we have liftoff.
