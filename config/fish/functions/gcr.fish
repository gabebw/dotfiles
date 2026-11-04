function gcr
  git fetch
  and set -f branch (git-select-branch --all)
  and if [ -n "$branch" ]
    git checkout $branch
    true
  end
end
