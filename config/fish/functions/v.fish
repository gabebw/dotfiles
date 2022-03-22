function v -a query
  if [ $PWD = $HOME ]
    echo "Refusing to run this in your home directory" >&2
    return 1
  end
  set -f files (fzf-tmux --query=$query --multi --exit-0)
  [ (count $files) -gt 0 ]; and $VISUAL $files
end
