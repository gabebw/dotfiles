##########
# Python #
##########
PYTHONSTARTUP=~/.python_startup

# If you install Python packages via pip, binaries will be installed under
# Python's cellar but not automatically linked into the Homebrew prefix.
PATH="$(brew --prefix python)"/bin:$PATH
