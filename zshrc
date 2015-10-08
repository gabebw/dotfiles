BASE="$HOME/.zsh"

for file in "$BASE"/before/*.zsh; do
  source "$file"
done

for file in "$BASE"/*.zsh
do
  if [[ "$file" != homebrew.zsh ]]; then
    # homebrew.zsh is sourced in zshenv for reasons explained in homebrew.zsh
    source "$file"
  fi
done

# brew install zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH

for file in "$BASE"/after/*.zsh; do
  source "$file"
done

# Houston, we have liftoff.
