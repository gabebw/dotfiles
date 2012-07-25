############
#  Erlang  #
############
location=$HOME/bin/erlang-R15B01/activate

if [[ -f "$location" ]]; then
  . $location
else
  . $HOME/bin/erlang_r15b01/activate
fi
