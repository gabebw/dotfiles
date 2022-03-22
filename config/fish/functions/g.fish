# By itself: run `git status`
# With arguments: acts like `git`
function g --wraps=git
  if [ (count $argv) -gt 0 ]
    git $argv
  else
    git st
  end
end
