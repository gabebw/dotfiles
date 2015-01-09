############
#  EDITOR  #
############

# Why set $VISUAL instead of $EDITOR?
# http://robots.thoughtbot.com/visual-ize-the-future
export VISUAL="vim -p"
alias vi="$VISUAL"
alias svi="sudo $VISUAL"

# Remove vim flags for crontab -e
alias crontab="VISUAL=vim crontab"

function viw {
  local location=$(which "$1")
  if [[ -f "$location" ]]; then
    vim "$location"
  else
    echo "$location isn't a file."
  fi
}

# complete viw like `which`
compdef viw=which
