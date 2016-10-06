##########
#  Ruby  #
##########

RUBYOPT=rubygems

# The goal here is:
# * ./bin/stubs is before rbenv shims
# * ~/.rbenv/shims is before /usr/local/bin etc
# * I don't know why it has to be in this order but putting shims before stubs
#   breaks stubs ("You have activated the wrong version of rake" error)
# * Yes, `rbenv init` adds ~/.rbenv/shims to the $PATH, but because it runs in
#   zshenv, a lot of other things add $PATH entries before ~/.rbenv/shims. This
#   is bad because it means that rbenv-installed programs don't have $PATH
#   primacy anymore.
PATH=./bin/stubs:~/.rbenv/shims:~/.rbenv/bin:$PATH

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
