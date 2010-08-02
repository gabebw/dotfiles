# ~/.profile is the one that actually gets sourced; ~/.bashrc is a symlink.
# to change shell: chsh -s /bin/bash
echo "sourcing bashrc"
unalias -a
# aliases file gives us qq alias, so do that first.
source ~/.dotfiles/extra/aliases
qq path

## shopt ##
# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# append history instead of overwriting
shopt -s histappend
# ignore same successive entries
export HISTCONTROL=ignoreboth
# ignore ls and cd (if they are called without arguments), and bg,
# fg, exit, and clear, _and_ any command prefaced with a space
export HISTIGNORE='&:clear:ls:cd:[bf]g:exit:[ t\]*'
# correct minor spelling mistakes
shopt -s cdspell
# don't autocomplete into these
export CDIGNORE=(.svn .DS_Store )

# hey, remember pbcopy and pbpaste! :)
# gabe@home$ echo "i will be copied"  | pbcopy
# gabe@home$ pbpaste
# => i will be copied
# [yay!]

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


# Keep as UTF-8 because en_US makes it choke when working with SVN, and not
# setting it at all gives odd "?" characters instead of accented characters.
alias hg="hg --encoding UTF-8"
# Add svn-python for mercurial (hg). Yes, you need to export.
export PYTHONPATH="$PYTHONPATH:/opt/subversion/lib/svn-python"

# voices
#alias robot="say -v fred"
## Marshall's robot voice from Three Days of Snow (HIMYM)
#alias marshall="say -v ralph"
#alias goodnews="say -v Good News"
#alias organ="say -v Pipe"

export EDITOR=vim
alias j=$EDITOR
alias macvim=mvim

# my ssh
#alias msh="ssh gbw@conch.unet.brandeis.edu" #:/usr/users/gbw/WWW/"
#alias ssh-cs="ssh gbw@themis.cs.brandeis.edu" #:/usr/users/gbw/WWW/"

#### Others ####
qq ruby
qq html
# Sets PATH with leading Python 2.6, so do it after other PATH stuff
#qq python
#qq ragel
#qq java
# mdfind has today, red, blue, etc
#qq mdfind
qq git # includes completion

# AFTER ~/.bash/ruby
ruby_version="\$(~/.rvm/bin/rvm-prompt v)"
# \w = full path; \W = basename
#PS1="\[\033[01;36m\] \[\033[01;31m\]\u\[\033[01;34m\] \W $\[\033[00;00m\] "
PS1="\033[01;34m\]\W $\[\033[00;00m\] "
export PS1="[${git_branch}$ruby_version] $PS1"
