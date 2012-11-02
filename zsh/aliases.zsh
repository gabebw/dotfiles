###########
# ALIASES #
###########
alias cp="cp -iv"
alias rm="rm -iv"
alias mv="mv -iv"
alias ls="ls -FGh"
alias du="du -cksh"
alias df="df -h"
# Use modern regexps for sed, i.e. "(one|two)", not "\(one\|two\)"
alias sed="sed -E"
alias noascii="sed 's/.\\[[0-9][0-9]?m//g'" # remove ASCII color codes
alias grep=egrep
alias grpe=grep # fix typo
alias pgrep="\grep -P" # PCRE-compatible
export GREP_OPTIONS="--color=auto" # removes color when piping
export GREP_COLOR='1;31' # highlight matches in red
[[ -x $(which colordiff) ]] && alias diff="colordiff -u" || alias diff="diff -u"
[[ -x $(which colormake) ]] && alias make=colormake
alias less="less -R" # correctly interpret ASCII color escapes
alias eject="drutil tray eject"

alias prettyjson="python -m json.tool"
alias prettyxml="xmllint --format -"

alias dotfiles="cd ~/.dotfiles"

# Global aliases
alias -g G="| grep "
alias -g ONE="| awk '{ print \$1}'"

function al { ls -t | head -n ${1:-10}; }
function m { open -a VLC "${@:-.}"; }
function p {
  if [[ $1 == '.' || $# == 0 ]]; then
    # Preview will sort them like Finder for you
    open -a Preview .
  else
    open -a Preview "$@"
  fi
}

alias q="$EDITOR ~/.zshrc"
alias qq="source ~/.zshrc"
