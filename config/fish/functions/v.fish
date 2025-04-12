function v -a query
  if [ $PWD = $HOME ]
    echo "Refusing to run this in your home directory" >&2
    return 1
  end

  # Check if $TERM_PROGRAM is set before running tests.
  # Otherwise it will show an error because it sees `[ = "vscode" ]`, which
  # isn't valid.
  set -f files (fzf --query=$query --multi --exit-0)
  [ (count $files) -gt 0 ]; and $VISUAL $files
end
