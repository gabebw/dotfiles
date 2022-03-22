function gc -w 'git branch'
  if [ (count $argv) -eq 0 ]
    set -f branch (select-git-branch)
    if [ -n $branch ]
      git checkout $branch
    end
    true
  else
    git checkout $argv
  end
end
