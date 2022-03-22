function git-branch-with-prefix
  if [ (count $argv) -eq 0 ]
    echo "No branch name :(" >&2
    return 1
  else
    gbm (string replace --all ' ' '-' (string join ' ' $argv))
  end
end
