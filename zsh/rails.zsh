#########
# RAILS #
#########

# Bundler
alias be="bundle exec"
alias bi="bundle check || bundle install --local || bundle install"
alias binstubs="bundle --binstubs=bundler_binstubs"

function b {
  if [[ $# == 0 ]]
  then
    bi
  else
    bundle "$@"
  fi
}

# Cucumber
alias cuc="be cucumber"
compdef cuc=cucumber

# Rspec
alias s=rspec
compdef s=rspec

# Rake
alias migrate="be rake db:migrate db:test:prepare"
alias remigrate="be rake db:migrate && be rake db:migrate:redo && be rake db:schema:dump db:test:prepare"
alias bake="be rake"
alias brake=bake
alias rrg="bake routes | grep"
alias reset-db="bake db:drop db:create && migrate"

# Test::Unit
alias tu="ruby -Itest"

# ctags
alias tagit='/usr/local/bin/ctags -R --languages=-javascript --langmap="ruby:+.rake.builder.rjs" --exclude=.git --exclude=log -f ./tmp/tags *'

# Via Dan Croak.
function staging-rake(){ heroku run rake "$@" --remote staging }
alias staging='heroku run console --remote staging'
alias staging-logs='bundle exec heroku logs --tail --remote staging'
alias staging-migrate='staging-rake db:migrate'

function production-rake(){ heroku run rake "$@" --remote production }
alias production='heroku run console --remote production'
alias production-logs='bundle exec heroku logs --tail --remote production'
alias production-migrate='production-rake rake db:migrate'

alias db-copy-production-to-staging='heroku pgbackups:restore DATABASE `heroku pgbackups:url --remote production` --remote staging  --confirm `basename $PWD`-staging'
alias db-backup-production='heroku pgbackups:capture --remote production'
