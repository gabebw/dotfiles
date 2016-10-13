############
# Homebrew #
############

if is_osx; then
  # Opt out of sending Homebrew information to Google Analytics
  # https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
  export HOMEBREW_NO_ANALYTICS=1

  HOMEBREW_PREFIX=/usr/local
  PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
  unset HOMEBREW_PREFIX
fi
