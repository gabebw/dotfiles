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
  gem uninstall -a capybara-webkit && \
    brew unlink qt qt5 && \
    brew link qt --overwrite && \
    b
}

# Install capybara-webkit linked against Qt5
capy5() {
  gem uninstall -a capybara-webkit && \
    brew unlink qt qt5 && \
    brew link qt5 --force --overwrite && \
    b
}
