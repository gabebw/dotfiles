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

source ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# zsh-syntax-highlighting must be sourced after all custom widgets have been
# created (i.e., after all zle -N calls and after running compinit), because it
# has to know about them to highlight them.
#
# However, zsh-syntax-highlighting also (somehow, because the source doesn't
# appear to do it) unsets the `print_exit_value` ZSH option, so re-source the
# options here so it sticks.
source ~/.zsh/options.zsh
