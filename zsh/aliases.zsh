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

function spell(){
  for file in **/*
  do
    aspell --lang=en --conf=~/aspell.conf -c "$file"
  done
}

alias get="curl -O"
function mp4convert(){
  input="$1"
  output="${1%.*}.mp4"
  if  [[ $# == 1 ]]; then
    HandbrakeCLI -i "$input" -o "$output"
  elif [[ $# == 2 ]]; then
    # specify start time in seconds
    HandbrakeCLI -i "$input" -o "$output" --start-at=duration:$2
  fi
}

# you can pipe pure "ls" output to "pp"
# See also:  echo ${(qqqfo)$(ls)}, via "man zshexpn"
# $'string' (vs 'string') quotes using the ANSI C standard, meaning you can
# put single quotes inside single quotes by '\''. Otherwise you flat-out can't
# put single quotes in a single-quoted string.
alias quote="sed -Ee $'s/([ \'\"])/\\\\\\\\\\\1/g'"
alias pp='quote | sort -df | xargs open -a Preview'
alias mm='quote | sort -df | xargs open -a VLC'

# List black & white images in current dir
function bandw() {
  for image in *
  do
    colorspace=$(identify -format "%[colorspace]" "$image" 2>/dev/null)
    [[ $? == 0 && $colorspace != "RGB" ]] && echo $image
  done
}

alias q="$EDITOR ~/.zshrc"
alias qq="source ~/.zshrc"
