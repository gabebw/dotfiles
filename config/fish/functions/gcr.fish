function gcr
  set -f branch (git-select-branch --all)
  if [ -n "$branch" ]
    git checkout $branch
    true
  end
end
