#########
# RAILS #
#########
# Bundler
alias b="bundle"
alias bi="bundle install --local || bundle install"
alias be="bundle exec"

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
