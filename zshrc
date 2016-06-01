BASE="$HOME/.zsh"

load_all_files_in() {
  if [ -d "$BASE/$1" ]; then
    for file in "$BASE/$1"/*.zsh; do
      source "$file"
    done
  fi
}

load_all_files_in before
load_all_files_in ""
load_all_files_in after

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Houston, we have liftoff.
