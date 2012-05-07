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

# Database
alias db-development-name='egrep "database:.*development" config/database.yml | awk "{print \$2}"'
alias db-reset="be rake db:drop db:create && migrate"
