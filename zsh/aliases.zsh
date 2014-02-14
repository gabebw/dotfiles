###########
# ALIASES #
###########
alias q="vim ~/.zshrc"
alias qq="source ~/.zshrc"
alias cp="cp -iv"
alias rm="rm -iv"
alias mv="mv -iv"
alias ls="ls -FGh"
alias du="du -cksh"
alias df="df -h"
# Use modern regexps for sed, i.e. "(one|two)", not "\(one\|two\)"
alias sed="sed -E"
[[ -x $(which colordiff) ]] && alias diff="colordiff -u" || alias diff="diff -u"
alias less="less -R" # correctly interpret ASCII color escapes

alias prettyjson="python -m json.tool"
alias prettyxml="xmllint --format -"

alias dotfiles="cd ~/.dotfiles"

# Needs to be a function because `alias -` breaks
function -() { cd - }

# Global aliases
alias -g G="| grep "
alias -g ONE="| awk '{ print \$1}'"

# Screw you, "no nodename or servname not provided". I'll do `whois
# http://google.com/` if I want.
function whois() {
  command whois $(echo $1 | sed -e 's|https?://||' -e 's|/||g')
}

function al { ls -t | head -n ${1:-10}; }
function p {
  if [[ $1 == '.' || $# == 0 ]]; then
    # Preview will sort them like Finder for you
    open -a Preview .
  else
    open -a Preview "$@"
  fi
}

icopy() {
  scp "$1" i:~/images
}
