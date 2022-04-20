function tcd -a directory session_name
  if [ (count $argv) -eq 1 ]
    if [ $directory = . ]
      set -f directory (greadlink -f $directory)
    end
    set -f session_name $(basename $argv[1])
  end

  set session_name (string replace ' ' '-' $session_name)

  fish -c "cd '$directory' && t $session_name"
end
