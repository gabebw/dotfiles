#########
# RAILS #
#########
# Bundler
alias b="bundle"
alias bi="bundle install --local || bundle install"
alias be="bundle exec"
alias guard="be guard"

# Cucumber
alias cuc="be cucumber"
compdef cuc=cucumber

# Rspec
alias spec="be rspec"

# Rake
alias migrate="be rake db:migrate db:test:prepare"
alias remigrate="be rake db:migrate && be rake db:migrate:redo && be rake db:schema:dump db:test:prepare"
alias bake="be rake"
alias brake=bake
alias take="RAILS_ENV=test be rake"
alias rrg="bake routes | grep"
alias reset-db="bake db:drop db:create && migrate"

# Via Dan Croak.
alias staging='heroku run console --remote staging'
alias staging-logs='bundle exec heroku logs --tail --remote staging'
alias migrate-production='heroku run rake db:migrate --remote staging'

alias production='heroku run console --remote production'
alias production-logs='bundle exec heroku logs --tail --remote production'
alias migrate-production='heroku run rake db:migrate --remote production'

alias db-pull-staging='heroku db:pull --remote staging --confirm `basename $PWD`-staging'
alias db-pull-production='heroku db:pull --remote production --confirm `basename $PWD`-production'
alias db-copy-production-to-staging='heroku pgbackups:restore DATABASE `heroku pgbackups:url --remote production` --remote staging  --confirm `basename $PWD`-staging'
alias db-backup-production='heroku pgbackups:capture --remote production'
