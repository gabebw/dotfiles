##########
#  Ruby  #
##########

RUBYOPT=rubygems

# rbenv
PATH=~/.rbenv/shims:$PATH

# Bundler binstubs
PATH="./bin/stubs:$PATH"

# Bundler
alias be="bundle exec"
alias binstubs="bundle --binstubs=./bin/stubs"

serveit(){
  if [[ $# != 1 ]]; then
    echo "Usage: 'serveit public' to serve the public directory"
  else
    echo "\n\n>>> http://localhost:9090\n\n"
    ruby -run -e httpd "$1" -p 9090
  fi
}

alias tagit='/usr/local/bin/ctags -R \
  --languages=-javascript \
  --langmap="ruby:+.rake.builder.rjs" \
  --exclude=.git \
  --exclude=log \
  --exclude=vendor \
  --exclude=db \
  --exclude=ext \
  --exclude=tmp \
  -f ./tags *'

function b {
  if [[ $# == 0 ]]
  then
    (bundle check > /dev/null || bundle install) && binstubs
  else
    bundle "$@"
  fi
}

# Install capybara-webkit linked against Qt4
capy4() {
  brew install qt qt55 && \
    gem uninstall -a capybara-webkit && \
    brew unlink qt qt55 && \
    brew link qt --overwrite && \
    b
}

# Install capybara-webkit linked against Qt5.5
capy5() {
  brew install qt qt55 && \
    gem uninstall -a capybara-webkit && \
    brew unlink qt qt55 && \
    brew link qt55 --force --overwrite && \
    b
}
