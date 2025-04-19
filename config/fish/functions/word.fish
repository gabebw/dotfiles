# Get word N from a line
function word -a n
  string trim | awk '{print $'$n' }'
end
