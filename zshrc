if [[ -z $TMUX ]]; then
  # Let's boot tmux before loading anything. Without this if/else, everything
  # loads in the "real", non-tmux terminal, slowing everything down by like
  # half.
  tmux attach
else
  # We're in tmux, GO GO GO

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
