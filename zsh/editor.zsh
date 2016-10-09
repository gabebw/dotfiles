############
#  EDITOR  #
############

# Why set $VISUAL instead of $EDITOR?
# http://robots.thoughtbot.com/visual-ize-the-future
export VISUAL=vim
alias vi="$VISUAL"
alias v="$VISUAL"

# Remove vim flags for crontab -e
alias crontab="VISUAL=vim crontab"
