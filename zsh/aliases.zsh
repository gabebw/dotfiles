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

function rsync_the_thing() {
  # Safely rsync,
  # without overwriting (--ignore-existing)
  rsync -e ssh -azh --ignore-existing "$@"
}
# icopy http://something.com/flip.jpg flip.jpg
# or
# icopy ./something.gif
icopy() {
  path_or_url="$1"
  basename_path=$(basename "$path_or_url")
  filename="${2:-$basename_path}"
  if [[ "$filename" != "$(basename "$filename")" ]]; then
    # Create any missing directories
    ssh i "cd images && mkdir -p $(dirname "$filename")"
  fi

  if [[ "$path_or_url" =~ "^http" ]]; then
    local_filename="$(basename "$filename")"
    echo $local_filename
    curl -o "$local_filename" "$path_or_url" && \
      rsync_the_thing "$local_filename" "i:~/images/$filename" && \
      rm -f "$local_filename"
  else
    # Not a URL
    rsync_the_thing "$path_or_url" "i:~/images/$filename"
  fi

  echo
  echo "http://i.gabebw.com/$filename"
}

serve() {
  port="${1:-3000}"
  echo "Serving on http://localhost:$port"
  echo "\n\n"
  ruby -run -e httpd . -p $port
}
