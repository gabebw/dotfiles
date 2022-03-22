function gcl
  set -f directory (superclone $argv)
  if [ $status -eq 0 ]
    cd $directory
  else
    return 1
  end
end
