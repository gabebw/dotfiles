function alr
  if [ (count $argv) -eq 0 ]
    ls -t -r | head -n 10
  else if [ (count $argv) -eq 1 ]; and string match -r '^[0-9]+$' $argv[1]
    ls -t -r | head -n $argv[1]
  else
    ls -t -r $argv | head -n 10
  end
end
