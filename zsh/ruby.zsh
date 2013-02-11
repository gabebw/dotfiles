##########
#  Ruby  #
##########
RUBYOPT=rubygems

# Bundler
alias be="bundle exec"
alias bi="bundle check || bundle install"
alias binstubs="bundle --binstubs=./bin/stubs"

# ctags
alias tagit='mkdir -p tmp/ && /usr/local/bin/ctags -R \
  --languages=-javascript \
  --langmap="ruby:+.rake.builder.rjs" \
  --exclude=.git \
  --exclude=log \
  --exclude=vendor \
  --exclude=db \
  --exclude=ext \
  --exclude=tmp \
  -f ./tmp/tags *'

function b {
  if [[ $# == 0 ]]
  then
    bi
  else
    bundle "$@"
  fi
}

# RSpec
alias s=rspec
compdef s=rspec
