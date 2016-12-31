#########
# RAILS #
#########

alias h=heroku
alias migrate="be rake db:migrate db:rollback && be rake db:migrate db:test:prepare"
alias rrg="be rake routes | grep"
alias db-reset="be rake db:drop db:create db:migrate db:test:prepare"
alias f=start_foreman_on_unused_port
