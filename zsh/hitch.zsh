##########
# HITCH  #
##########
# Get it here: https://github.com/therubymug/hitch
# To install hitch:
# for x in $(rvm list strings); do rvm use $x@global && gem install hitch; done
hitch() {
  command hitch "$@"
  [[ -s "$HOME/.hitch_export_authors" ]] && source "$HOME/.hitch_export_authors"
}
alias unhitch='hitch -u'
