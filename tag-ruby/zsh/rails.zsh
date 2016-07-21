#########
# RAILS #
#########

alias h=heroku

# Rake
alias migrate="be rake db:migrate db:rollback db:migrate db:test:prepare"
alias rrg="be rake routes | grep"

# Database
alias db-reset="be rake db:drop db:create db:migrate db:test:prepare"

alias f=start_foreman_on_unused_port
