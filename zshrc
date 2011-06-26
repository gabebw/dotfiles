# Vim-style line editing
bindkey -v
# I want my bck-i-search
bindkey -M viins "^r" history-incremental-search-backward
bindkey -M vicmd "f" history-incremental-search-backward
autoload zkbd
# Create an empty $key array so that setting $key[subscript] below doesn't
# fail if $key doesn't exist
typeset -g -A key

# Set some defaults. Use -z, not -e, because we're checking that it's set to
# an empty string.
[[ -z "${key[Home]}" ]] && key[Home]='^[[H'
[[ -z "${key[End]}" ]] && key[End]='^[[F'

# Via http://dev.codemac.net/?p=config.git;a=blob_plain;f=zsh/env;h=350939a5c6b890e91a0a3bfec6e7c96c21fd8d5b
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
# This will make ZSH hesitate every time you press backspace. Don't do it.
#[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

############
#  COLORS  #
############
# allows e.g. $fg[blue] and $bg[green]
autoload -Uz colors && colors
zmodload -i zsh/complist # colorful listings
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

############
#  EDITOR  #
############
# don't set it to macvim, zsh has troubles with double-aliases
export EDITOR="mvim -p" # -p = 1 tab/file
alias vi="mvim -p"
alias svi="sudo $EDITOR"

# Use non-Macvim for crontab -e
alias crontab="EDITOR=vim crontab"

function viw {
  local location=$(which "$1")
  if [[ -f "$location" ]]; then
    vim "$location"
  else
    echo "$location isn't a file."
  fi
}

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

function al { ls -t | head -n ${1:-10}; }
function m { open -a VLC "${@:-.}"; }
function p { open -a Preview "${@:-.}"; }

# you can pipe pure "ls" output to "pp"
# See also:  echo ${(qqqfo)$(ls)}, via "man zshexpn"
# $'string' (vs 'string') quotes using the ANSI C standard, meaning you can
# put single quotes inside single quotes by '\''. Otherwise you flat-out can't
# put single quotes in a single-quoted stringput single quotes in a
# single-quoted string.
alias quote="sed -Ee $'s/([ \'\"])/\\\\\\\\\\\1/g'"
alias pp='quote | xargs open -a Preview'
alias mm='quote | xargs open -a VLC'
alias q="$EDITOR ~/.zshrc"
alias qq="source ~/.zshrc"

########
# PATH #
########

# DO NOT SET PATH ANEW - always use $PATH and your stuff before/after it
# * note that setting it anew breaks rvm
# /etc/profile gives us these
# /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/X11/bin

# Removes duplicate PATH entries but keeps the original order.
trim_path() {
  # http://chunchung.blogspot.com/2007/11/remove-duplicate-paths-from-path-in.html
  export PATH=$(awk -F: '{for(i=1;i<=NF;i++){if(!($i in a)){a[$i];printf s$i;s=":"}}}'<<<$PATH)
}
# So I can tell ZSH to scan the PATH for newly-installed programs, without
# running the whole bootup process all over again. And yes, I used to use
# Gentoo.
# Wrap it in a function so it's evaluated at run-time.
env-update() { export PATH=$PATH; }

MANPATH=/usr/share/man:/usr/local/share/man:/usr/X11/share/man:/usr/X11/man:/usr/local/man

# TeX
pdflatex_dir='/usr/local/texlive/2010/bin/x86_64-darwin'
[[ -x ${pdflatex_dir}/pdflatex ]] && PATH="$PATH:$pdflatex_dir"
unset pdflatex_dir

# My scripts are always last. Use full path instead of ~/ so that "which" works.
PATH="$PATH:/Users/gabe/bin"
PATH="/usr/local/bin:$PATH" # homebrew

#################
#  ZSH options  #
#################
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt no_list_beep
setopt appendhistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt autocd
setopt prompt_subst
unsetopt correctall

################
#  COMPLETION  #
################
fpath=(~/.dotfiles/zsh/completion-scripts $fpath)
autoload -U compinit && compinit

# complete command names, inc. aliases, shell functions, builtins and reserved
# words.
#compctl -m viw
# complete viw like `which`
compdef viw=which

#######################
#  GIT (branch, vcs)  #
#######################
autoload -Uz vcs_info
# run before setting $PS1 each time
function precmd { vcs_info 'prompt'; }
# colors
PR_RESET="%{${reset_color}%}"
BRANCH="%{$fg[red]%}"
PAREN_COLOR="%{$fg[green]%}"
PAREN_OPEN="${PAREN_COLOR}(%f"
PAREN_CLOSE="${PAREN_COLOR})%f"
BASIC_BRANCH="${BRANCH}%b${PR_RESET}" # e.g. "master"
FMT_BRANCH="${PAREN_OPEN}${BASIC_BRANCH}${PAREN_CLOSE}" # add parens

zstyle ':vcs_info:*' enable git hg svn
# Note leading space!
zstyle ':vcs_info:*' formats " ${FMT_BRANCH}${PR_RESET}"

# Must use print (not echo) for ZSH colors to work
git_branch() { print "${vcs_info_msg_0_}$(parse_git_dirty)"; }

# Stolen from oh-my-zsh
parse_git_dirty(){ [[ -n $(git status -s 2> /dev/null) ]] && echo ' ✗'; }

##########
# PROMPT #
##########
# MUST wrap $fg in %{...%} or it creates weird errors with commands >1 line
# Use %f to reset color and use terminal default colors (set in Terminal prefs)
export PROMPT="[\$(ruby_version)\$(git_branch)] %{$fg[blue]%}%~ %{$fg[green]%}$%f " 
############################
#         EXTRAS           #
# (non-core functionality) #
############################

############
# Homebrew #
############
HOMEBREW_PREFIX=/usr/local # "$(brew --prefix)"
PATH="$HOMEBREW_PREFIX"/bin:$PATH
PATH="$HOMEBREW_PREFIX"/sbin:$PATH
# android-ndk doesn't put symlinks in /usr/local/bin
PATH="$PATH:$(brew --prefix android-ndk)"
# Allows running "emulator -avd em21" from command line
export ANDROID_SDK_ROOT=/usr/local/var/lib/android-sdk

# If you install Python packages via pip, binaries will be installed under
# Python's cellar but not automatically linked into the Homebrew prefix.
PATH="$(brew --prefix python)"/bin:$PATH
unset HOMEBREW_PREFIX

##########
# Python #
##########
PYTHONSTARTUP=~/.python_startup

#######
# Git #
#######
alias g=git
alias gp="git push"
alias gd="git diff"

alias ga="git add"
alias gai="git add --interactive"

alias gb="git branch"
alias gcb="git checkout -b"
alias gc="git checkout"
alias gst="git st" # Use my alias from ~/.gitconfig
alias gcm="git commit -m"

##########
#  Ruby  #
##########
RUBYOPT=rubygems

#########
# RAILS #
#########
# Bundler
alias b="bundle"
alias bi="bundle install --without production"
alias be="bundle exec"

# Cucumber
alias cuc="be cucumber"
compdef cuc=cucumber
alias wip="be rake cucumber:wip"

# tests
alias rtu="be rake test:units"
alias rtf="be rake test:functionals"
alias rtc="be rake test:recent"
alias rtp="be rake test:plugins"
alias rti="be rake test:integration"

alias migrate="be rake db:migrate db:test:prepare"
alias remigrate="be rake db:migrate && be rake db:migrate:redo && be rake db:schema:dump db:test:prepare"
alias trake="RAILS_ENV=test be rake"
alias rspec="be rspec"

#######
# RVM #
#######
# Double check that we have a good installation of RVM
if [[ ! (-d ~/.rvm && -s "$HOME/.rvm/scripts/rvm" && -x ~/.rvm/bin/rvm-prompt) ]]
then
  # No rvm, fake it.
  echo "WARNING: no rvm, faking it."
  ruby_version(){ print "%{$fg[magenta]%}system%{$reset_color%}"; }
else
  # only source rvm once
  [[ x = "${rvmrc}x" ]] && source "$HOME/.rvm/scripts/rvm"

  ruby_version() {
    # rvm-prompt options:
    # i => interpreter ("ree", "ruby", "macruby")
    # v => version ("1.8.7", "0.6")
    #   i + v => "ree-1.8.7" or "macruby-0.6"
    # g => gemset ("@rails3")
    # s => print "system" if using system intepreter (otherwise blank, for
    # 	   some reason)
    print "%{$fg[magenta]%}${$(~/.rvm/bin/rvm-prompt i v g s)#ruby-}%{$reset_color%}"
  }
fi

rgcu() { rvm gemset create "$1" && rvm gemset use "$1"; }

#######
# NPM #
#######
#PATH="$PATH:/Users/gabe/.npm_root/bin/"
PATH="$PATH:/Users/gabe/.npm/coffee-script/1.0.1/package/bin"


export PATH
trim_path

# Houston, we have liftoff.
