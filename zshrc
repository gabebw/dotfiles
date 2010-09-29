# This might help: http://dotfiles.org/.zshrc
# to change shell: chsh -s /bin/zsh
#
# Okay, useful stuff:
# fc: opens an editor (default vi) to edit the last command
# r: redoes last command with optional changes, e.g.
# cal/ncal: gives you an ASCII calendar
# echo foo  # => "foo"
# r foo=bar # => "bar"
# hashing: hash -d HASH=directory, then "cd ~HASH"
# Do not use ~ in the directory, either. Use /Users/gabe/.
# http://michael-prokop.at/blog/2008/12/01/mikas-advent-calendar-day-1/

########################################
#  INIT (everything depends on these)  #
########################################
# aliases file gives us source_extra alias, so do that first.
source ~/.dotfiles/zsh/alias
source ~/.dotfiles/zsh/path

#################
#  ZSH options  #
#################
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=1000
setopt no_list_beep
setopt appendhistory
# don't store history line if it's the same as the previous one
setopt hist_ignore_all_dups
# Removes meaningless whitespace
# so "echo 'asdf 1234'    " -> "echo 'asdf 1234'"
setopt hist_reduce_blanks
# autocd: simply type name of directory and you cd to it
setopt autocd
setopt extendedglob
setopt cdablevars
# correct: correct commands
# correctall: correct commmands AND arguments
unsetopt correctall
# allow commands in prompt
setopt prompt_subst

################
#  COMPLETION  #
################
autoload -U compinit && compinit
# see "man 1 zshcompctl"
# This sets edit_extra to be completed with stuff in ~/.dotfiles/extra without
# showing the ~/.dotfiles/extra part, so you type "edit_extra u<TAB>" -> "edit_extra util"
compctl -f -W ~/.dotfiles/extra/ edit_extra
compctl -f -W ~/.dotfiles/extra/ source_extra
# complete command names, inc. aliases, shell functions, builtins and reserved
# words.
compctl -m viw

############
#  COLORS  #
############
# allows e.g. $fg[blue] and $bg[green]
autoload colors && colors
## colorful listings
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

##############
#  KEYBOARD  #
##############
autoload zkbd
[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd
source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE
# http://www.zsh.org/mla/users/2009/msg00124.html
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

#######################
#  GIT (branch, vcs)  #
#######################
# I have only a faint idea of what this does: it is cobbled together from the web
# this is helpful: http://kriener.org/articles/2009/06/04/zsh-prompt-magic
## set formats:
# In normal formats and actionformats:
#  %s - vcs in use (git, svn, etc)
#  %b - info about current branch
#  %a -
#  %b - branchname
#  %u - unstagedstr (see below)
#  %c - stagedstr (see below)
#  %a - action (e.g. rebase-i) [only makes sense in actionformats]
#  %R - base dir of repository
#  %r - repository name. If %R is /foo/bar/repoXY, %r is repoXY.
#  %S - path in the repository. If $PWD is /foo/bar/reposXY/beer/tasty,
#  		%S is "beer/tasty".
#  - you probably want %R/%S -> "~/repo/subdir"
# In branchformat:
#  %b - the branch name
#  %r - the current revision number
## colors as %F{n}: (advantage of not needing %{...%}
# 1: red (%F{1})
# 2: green
# 3: yellow
# 4: blue
# 5: purple
# 6: cyan
# 7: gray
# 8: black
# %f: reset color
autoload -Uz vcs_info
# colors
PR_RESET="%{${reset_color}%}"
BRANCH="%{$fg[red]%}"
PAREN_COLOR="%{$fg[green]%}"
PAREN_OPEN="${PAREN_COLOR}(%f"
PAREN_CLOSE="${PAREN_COLOR})%f"

BASIC_BRANCH="${BRANCH}%b${PR_RESET}" # e.g. "master"
FMT_BRANCH="${PAREN_OPEN}${BASIC_BRANCH}${PAREN_CLOSE}" # add parens

#### START INFO BLOCK
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#SEC273
# :vcs_info:<vcs-string>:<user-context>:<repo-root-name>
# 	<vcs-string>: one of: git, svn, cvs, etc.
# 	<user-context>: a freely configurable string, assignable by the user as
# 				  	the first argument to vcs_info.
# 	<repo-root-name>: the name of a repository in which you want a style to
# 					  match.  So, if you want a setting specific to
# 					  /usr/src/zsh, with that being a cvs checkout, you can
# 					  set <repo-root-name>  to zsh to make it so.
#
# just type zstyle to see current styles
# For more on style:
#  http://zsh.sourceforge.net/Doc/Release/zsh_21.html#SEC182
# "zstyle -d" to delete all defs
#### END INFO BLOCK
zstyle ':vcs_info:*' enable git # disables all other VCSes
# Note leading space!
zstyle ':vcs_info:*' formats " ${FMT_BRANCH}${PR_RESET}"

############
#  EDITOR  #
############
alias macvim=mvim
export EDITOR=macvim
alias j=$EDITOR
alias vi=macvim
alias vim=macvim

############
#  EXTRAS  #
############
source_extra util
source_extra ruby # pulls in rails
#source_extra html
# Sets PATH with leading Python 2.6, so do it after other PATH stuff
#source_extra python
#source_extra ragel
source_extra mdfind # has today(), red(), blue(), etc
source_extra java
source_extra git # includes completion if using bash
source_extra jbs
source_extra android
source_extra school

function precmd {
  vcs_info 'prompt'
}

# via http://everything2.com/e2node/Good%2520%2525GREETING_TIME%252C%2520%2525FULL_NAME
HOUR=`/bin/date +%H`
USER=`whoami`
if [ $HOUR -lt 5 ] ; then
  # midnight - 4:59am
  GREETING_TIME="night"
elif [ $HOUR -lt 12 ] ; then
  # 5 am - 11:59am
  GREETING_TIME="morning"
elif [ $HOUR -lt 18 ] ; then
  # noon - 5:59pm
  GREETING_TIME="afternoon"
else
  # 6pm - 11:59pm
  GREETING_TIME="evening"
fi
echo "Good $GREETING_TIME, $USER. Your wish is my command."

# MUST wrap $fg in %{...%} or it creates weird errors with commands >1 line
# Use %f to reset color and use terminal default colors (set in Terminal prefs)
PROMPT="[\$(ruby_version)\$(git_branch)] %{$fg[blue]%}%~ %{$fg[green]%}$%f "
