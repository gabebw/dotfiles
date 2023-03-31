function v -a query
  if [ $PWD = $HOME ]
    echo "Refusing to run this in your home directory" >&2
    return 1
  end

  # Check if $TERM_PROGRAM is set before running tests.
  # Otherwise it will show an error because it sees `[ = "vscode" ]`, which
  # isn't valid.
  if set -q TERM_PROGRAM && [ $TERM_PROGRAM = "vscode" ]
    set -f files (fzf --query=$query --multi --exit-0)
  else
    set -f files (fzf-tmux --query=$query --multi --exit-0)
  end
  [ (count $files) -gt 0 ]; and $VISUAL $files
end
