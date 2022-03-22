# Get word N from a line
function word -a n
  # Assume we're piping in and read STDIN
  read --local stdin
  string split ' ' -f $n $stdin
end
