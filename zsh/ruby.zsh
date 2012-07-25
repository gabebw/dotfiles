##########
#  Ruby  #
##########
RUBYOPT=rubygems

ruby_version(){ print "%{$fg[magenta]%}${$(ruby --version | awk '{print $2}')#ruby-}%{$reset_color%}"; }
