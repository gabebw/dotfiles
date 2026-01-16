function gb -a branch base --wraps 'git switch'
  if [ (count $argv) -eq 0 ]
    echo "No branch name :(" >&2
    return 1
  end
  if [ -n "$base" ]
    git switch --create $branch $base
  else
    git switch --create $branch
  end
end
