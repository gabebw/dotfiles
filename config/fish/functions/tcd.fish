function tcd -a directory session_name
  # readlink for 2 reasons:
  # 1) to dereference `.` or `..` into actual directories
  # 2) So that tmux's `session_path` variable is an absolute directory
  set -f directory (readlink -f $directory)

  if [ -z $session_name ]
    set -f session_name $(basename $directory)
  end

  set session_name (string replace ' ' '-' $session_name)

  t $session_name $directory
end
