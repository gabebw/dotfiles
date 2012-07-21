if [[ -n $TMUX ]]; then
  # Let's make sure we're in tmux boots before loading anything. Without this if,
  # everything loads in the "real", non-tmux terminal, slowing everything down
  # by like half.

  BASE="$HOME/.dotfiles/zsh/"

  source $BASE'key_bindings.zsh'
  source $BASE'navigation.zsh'
  source $BASE'colors.zsh'
  source $BASE'editor.zsh'
  source $BASE'aliases.zsh'
  source $BASE'path.zsh'
  source $BASE'options.zsh'
  source $BASE'completion.zsh'
  source $BASE'vcs.zsh'
  source $BASE'prompt.zsh'

  ############################
  #         EXTRAS           #
  # (non-core functionality) #
  ############################

  for extra in homebrew git ruby rails rbenv hitch psql twios tmux arduino
  do
    source ${BASE}${extra}.zsh
  done

  source $BASE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  export PATH
  trim_path

  # [In]offensive short fortunes, where short means <= 140 chars
  fortune -a -s -n140

  # Houston, we have liftoff.
fi
