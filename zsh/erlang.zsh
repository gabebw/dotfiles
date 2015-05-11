############
#  Erlang  #
############
location=$HOME/bin/erlang-R16B02/activate

if [[ -f "$location" ]]; then
  . $location
fi

# erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell
erlang_version(){ print "%{$fg[magenta]%}${$( erl -noshell -eval 'io:fwrite("erlang-~s\n", [erlang:system_info(otp_release)]).' -s erlang halt)#}%{$reset_color%}"; }
