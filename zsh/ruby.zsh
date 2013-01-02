##########
#  Ruby  #
##########
RUBYOPT=rubygems

# Bundler
alias be="bundle exec"
alias bi="bundle check || bundle install"
alias binstubs="bundle --binstubs=bundler_binstubs"

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
