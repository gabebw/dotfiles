function al -a directory
  if [ -d "$directory" ]
    lister -n 10 -s modified $directory
  else
    lister $argv
  end
end
