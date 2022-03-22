function gb -a branch base
  if [ (count $argv) -eq 0 ]
    echo "No branch name :(" >&2
    return 1
  end
  if [ -n "$base" ]
    git checkout -b $branch $base
  else
    git checkout -b $branch
  end
end
