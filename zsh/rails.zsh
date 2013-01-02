#########
# RAILS #
#########

# Rake
alias migrate="be rake db:migrate db:test:prepare"
alias remigrate="be rake db:migrate && be rake db:migrate:redo && be rake db:schema:dump db:test:prepare"
alias rrg="be rake routes | grep"

# Test::Unit
alias tu="ruby -Itest"

# ctags
alias tagit='/usr/local/bin/ctags -R --languages=-javascript --langmap="ruby:+.rake.builder.rjs" --exclude=.git --exclude=log -f ./tmp/tags *'

alias h=heroku

function staging-rake(){ h run rake "$@" -r staging }
alias staging='h run console -r staging'
alias staging-logs='h logs --tail -r staging'
alias staging-migrate='staging-rake db:migrate'

function production-rake(){ h run rake "$@" -r production }
alias production='h run console -r production'
alias production-logs='h logs --tail -r production'
alias production-migrate='production-rake rake db:migrate'

# Database
alias db-development-name='egrep "database:.*development" config/database.yml | awk "{print \$2}"'
alias db-copy-staging-to-local='h pgbackups:capture -r staging && curl `h pgbackups:url -r staging` | db-restore `db-development-name`'
alias db-copy-production-to-staging='h pgbackups:restore DATABASE `h pgbackups:url -r production` -r staging  --confirm `basename $PWD`-staging'
alias db-backup-production='h pgbackups:capture -r production'
alias db-reset="be rake db:drop db:create && migrate"
