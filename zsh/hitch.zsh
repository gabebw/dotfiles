##########
# HITCH  #
##########
# Get it here: https://github.com/therubymug/hitch
hitch() {
  command hitch "$@"
  [[ -s "$HOME/.hitch_export_authors" ]] && source "$HOME/.hitch_export_authors"
}
alias unhitch='hitch -u'
