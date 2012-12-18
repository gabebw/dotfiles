#########
# RAILS #
#########

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

# Rspec
alias s=rspec
compdef s=rspec

# Rake
alias migrate="be rake db:migrate db:test:prepare"
alias remigrate="be rake db:migrate && be rake db:migrate:redo && be rake db:schema:dump db:test:prepare"
alias rrg="be rake routes | grep"

# Test::Unit
alias tu="ruby -Itest"

# ctags
alias tagit='/usr/local/bin/ctags -R --languages=-javascript --langmap="ruby:+.rake.builder.rjs" --exclude=.git --exclude=log -f ./tmp/tags *'

function staging-rake(){ heroku run rake "$@" -r staging }
alias staging='heroku run console -r staging'
alias staging-logs='heroku logs --tail -r staging'
alias staging-migrate='staging-rake db:migrate'

function production-rake(){ heroku run rake "$@" -r production }
alias production='heroku run console -r production'
alias production-logs='heroku logs --tail -r production'
alias production-migrate='production-rake rake db:migrate'

# Database
alias db-development-name='egrep "database:.*development" config/database.yml | awk "{print \$2}"'
alias db-copy-staging-to-local='heroku pgbackups:capture -r staging && curl `heroku pgbackups:url -r staging` | db-restore `db-development-name`'
alias db-copy-production-to-staging='heroku pgbackups:restore DATABASE `heroku pgbackups:url -r production` -r staging  --confirm `basename $PWD`-staging'
alias db-backup-production='heroku pgbackups:capture -r production'
alias db-reset="be rake db:drop db:create && migrate"
