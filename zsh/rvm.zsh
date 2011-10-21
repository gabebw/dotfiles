#######
# RVM #
#######
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
  ruby_version() {
    # rvm-prompt options:
    # i => interpreter ("ree", "ruby", "macruby")
    # v => version ("1.8.7", "0.6")
    #   i + v => "ree-1.8.7" or "macruby-0.6"
    # g => gemset ("@rails3")
    # s => print "system" if using system intepreter (otherwise blank, for
    #      some reason)
    print "%{$fg[magenta]%}${$(~/.rvm/bin/rvm-prompt i v g s)#ruby-}%{$reset_color%}"
  }
else
  # No rvm, fake it.
  echo "WARNING: no rvm, faking it."
  ruby_version(){ print "%{$fg[magenta]%}system%{$reset_color%}"; }
fi

rgcu() { rvm gemset create "$1" && rvm gemset use "$1"; }
