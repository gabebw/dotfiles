function tcd -a directory session_name
  if [ $directory = . ] || [ $directory = .. ]
    set -f directory (greadlink -f $directory)
  end

  if [ -z $session_name ]
    set -f session_name $(basename $directory)
  end

  set session_name (string replace ' ' '-' $session_name)

  t $session_name $directory
end
