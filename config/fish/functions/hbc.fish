function hbc -a branch
  string length -q -- $branch; or set branch (git-shalector)

  if [ (string length $branch) -gt 0 ]
    hub browse -- commit/$branch
  end
end
