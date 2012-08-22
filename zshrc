if [[ -n $TMUX ]]; then
  # Let's make sure we're in tmux boots before loading anything. Without this if,
  # everything loads in the "real", non-tmux terminal, slowing everything down
  # by like half.

  BASE="$HOME/.dotfiles/zsh"

  CORE=(
    key_bindings
    # "tmux" needs to be before "navigation" because of current-tmux-session
    tmux
    navigation
    colors
    editor
    aliases
    path
    options
    completion
    vcs
    prompt
  )

  ############################
  #         EXTRAS           #
  # (non-core functionality) #
  ############################
  EXTRA=(
    homebrew
    git
    ruby
    rails
    rbenv
    hitch
    psql
    twios
    arduino
  )

  for core in $CORE
  do
    source $BASE/$core.zsh
  done

  for extra in $EXTRA
  do
    source $BASE/$extra.zsh
  done

  source $BASE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  export PATH
  trim_path

  # [In]offensive short fortunes, where short means <= 140 chars
  fortune -a -s -n140

  # Houston, we have liftoff.
fi
