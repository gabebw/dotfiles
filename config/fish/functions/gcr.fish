function gcr
  set -f branch (select-git-branch --all)
  if [ -n "$branch" ]
    git checkout $branch
    true
  end
end
