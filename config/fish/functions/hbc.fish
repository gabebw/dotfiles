function hbc -a commit
  string length -q -- $commit; or set commit (git-shalector)

  if [ (string length $commit) -gt 0 ]
    gh browse $commit
  end
end
