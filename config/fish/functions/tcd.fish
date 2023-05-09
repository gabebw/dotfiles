function tcd -a directory session_name
  if [ $directory = . ]
    set -f directory (greadlink -f $directory)
  end

  if [ -z $session_name ]
    set -f session_name $(basename $directory)
  end

  set session_name (string replace ' ' '-' $session_name)

  fish -c "cd '$directory' && t $session_name"
end
