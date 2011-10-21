############
# Homebrew #
############
HOMEBREW_PREFIX=/usr/local
PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH

# If you install Python packages via pip, binaries will be installed under
# Python's cellar but not automatically linked into the Homebrew prefix.
PATH="$(brew --prefix python)"/bin:$PATH
unset HOMEBREW_PREFIX
