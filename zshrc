BASE="$HOME/.dotfiles/zsh"

# First, ensure we're in tmux
source "$BASE/tmux.zsh"
ensure_we_are_inside_tmux

for file in "$BASE"/*.zsh
do
  if [[ "$file" != homebrew.zsh && "$file" != tmux.zsh ]]; then
    # homebrew.zsh is sourced in zshenv for reasons explained in homebrew.zsh
    source "$file"
  fi
done

# brew install zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH
current

echo "Remember to use j"

# Houston, we have liftoff.
