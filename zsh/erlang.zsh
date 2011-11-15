############
#  Erlang  #
############
location=$HOME/bin/erlang-R14B04/activate

if [[ -f "$location" ]]; then
  . $location
else
  . $HOME/bin/erlang_r14b04/activate
fi
