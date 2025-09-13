# By itself: run `git status`
# With arguments: acts like `git`
function g --wraps=git
  if [ (count $argv) -gt 0 ]
    if string match -qe "~" -- $argv[2]
      echo "Use `lazygit log`" >&2
      return 1
    end

    git $argv
  else
    git status --short --branch
  end
end
