########
# PATH #
########

# Homebrew
PATH="/usr/local/bin:$PATH"

# Heroku standalone client
PATH="/usr/local/heroku/bin:$PATH"

# Tex
# Add whatever version of Tex we have to $PATH
# If this worked, I'd do it:
# PATH="$PATH:/usr/local/texlive/*/bin/universal-darwin"
for dir in /usr/local/texlive/*
do
  PATH="$PATH:${dir}/bin/universal-darwin"
done

# rbenv
PATH=~/.rbenv/shims:$PATH

# Bundler binstubs
PATH="./bin/stubs:$PATH"

# Node
PATH=$PATH:/usr/local/share/npm/bin

PATH=$HOME/.dotfiles/bin:$PATH
