############
#  EDITOR  #
############

# Why set $VISUAL instead of $EDITOR?
# http://robots.thoughtbot.com/visual-ize-the-future
export VISUAL="vim -p"
alias vi="$VISUAL"

# Remove vim flags for crontab -e
alias crontab="VISUAL=vim crontab"
