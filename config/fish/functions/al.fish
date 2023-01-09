function al -a number
  if [ $PWD = $HOME ]
    echo "Not running this in \$HOME."
    return 1
  end

  # Default to 10 results if no number was set
  set -q number[1]; or set number 10

  lister -n $number -s modified
end
