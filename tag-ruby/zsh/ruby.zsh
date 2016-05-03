##########
#  Ruby  #
##########

RUBYOPT=rubygems

# rbenv
PATH=~/.rbenv/shims:$PATH

# Bundler binstubs (bin/stubs is for backwards compatibility with old projects
# where I generated stubs into bin/stubs)
PATH="./bin/:./bin/stubs:$PATH"

# Bundler
alias be="bundle exec"

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
    (bundle check > /dev/null || bundle install) && bundle --binstubs
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
