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

# correctly interpret ASCII color escapes
alias less="less -R"

alias prettyjson="python -m json.tool"
alias prettyxml="xmllint --format -"

alias dotfiles="cd ~/.dotfiles"

# Needs to be a function because `alias -` breaks
function -() { cd - }

# Global aliases
alias -g G="| grep "
alias -g ONE="| awk '{ print \$1}'"

# Psh, "no nodename or servname not provided". I'll do `whois
# http://google.com/` if I want.
function whois() {
  command whois $(echo $1 | sed -e 's|https?://||' -e 's|/||g')
}

function al { ls -t | head -n ${1:-10}; }

# icopy http://something.com/flip.jpg flip.jpg
# or
# icopy ./something.gif
icopy() {
  path_or_url="$1"
  basename_path=$(basename "$path_or_url")
  filename="${2:-$basename_path}"
  if [[ "$path" =~ "^http" ]]; then
    curl -o "$filename" "$path_or_url" && \
      rsync -e ssh -azh --ignore-existing "$filename" i:~/images/ && \
      rm -f "$filename"
  else
    # Not a URL
    rsync -e ssh -azh --ignore-existing "$path_or_url" "i:~/images/$filename"
  fi
}

serve() {
  port="${1:-3000}"
  echo "Serving on http://localhost:$port"
  echo "\n\n"
  ruby -run -e httpd . -p $port
}
