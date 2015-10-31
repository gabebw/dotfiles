BASE="$HOME/.zsh"

load_all_files_in() {
  for file in "$BASE/$1"/*.zsh; do
    source "$file"
  done
}

load_all_files_in before
load_all_files_in ""
load_all_files_in after

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Houston, we have liftoff.
