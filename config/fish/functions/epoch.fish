function epoch
  if [ (count $argv) -eq 0 ]
    # Print the current epoch
    date +%s
  else
    # Parse the given epoch
    date -r $argv[1]
  end
end
