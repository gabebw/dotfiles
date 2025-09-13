function al -a where number
  # Default to listing $PWD
  [ -z $where ] && set where $PWD
  # Default to 10 results if no number was set
  [ -z $number ] && set number 10

  if [ $where = $HOME ]
    echo "Not running this in \$HOME."
    return 1
  end

  eza -s modified --recurse --reverse --oneline --only-files --absolute $where | rg -v ':$|^$' | head -n $number
end
