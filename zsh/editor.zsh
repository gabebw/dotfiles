############
#  EDITOR  #
############
export EDITOR="vim -p" # -p = 1 tab/file
alias vi="$EDITOR"
alias svi="sudo vim"

# Remove vim flags for crontab -e
alias crontab="EDITOR=vim crontab"

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
