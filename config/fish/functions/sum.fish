function sum
  # Assume we're piping in and read STDIN into one array of all the numbers
  read --local --list stdin
  string join "+" $stdin | bc
end
