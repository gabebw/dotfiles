function delete-branches-from-my-prs
  set branchname $(main-or-master-branch)
  git fetch
  and for branch_name in (gh pr list --state merged --base $branchname --author gabebw --json headRefName | jq 'map(.headRefName) | .[]' --raw-output)
    if git rev-parse --verify --quiet refs/heads/$branch_name > /dev/null
      echo $branch_name
    end
  end | \
    sort -u | \
    fzf --header "Select merged branches to delete (all selected by default)" --multi --bind start:toggle-all --sync --exit-0 | \
    xargs git branch -D
end
