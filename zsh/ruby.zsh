##########
#  Ruby  #
##########

RUBYOPT=rubygems

# Bundler
alias be="bundle exec"
alias binstubs="bundle --binstubs=./bin/stubs"

alias irb=pry

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

# RSpec
alias s=rspec
compdef s=rspec
