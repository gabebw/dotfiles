# Get word N from a line
function word -a n
  # Why `cat 1>|`?
  # https://github.com/fish-shell/fish-shell/issues/206#issuecomment-255232968
  cat 1>| string trim | awk '{print $'$n' }'
end
