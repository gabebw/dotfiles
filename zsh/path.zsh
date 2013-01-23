########
# PATH #
########

# Re-scan $PATH for newly-installed programs.
env-update() { export PATH=$PATH; }

# Homebrew
PATH="/usr/local/bin:$PATH"

# Heroku standalone client
PATH="/usr/local/heroku/bin:$PATH"

# Tex
PATH="$PATH:/usr/local/texlive/2012basic/bin/universal-darwin"

# Bundler binstubs
PATH="./bin/stubs:$PATH"

PATH=$HOME/.dotfiles/bin:$PATH
