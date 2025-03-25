# Grep immediately on opening vim
function gv
  if [ (count $argv) -ne 1 ]
    echo "Usage: gv THING_TO_GREP_FOR" >&2
    return 64
  else
    nvim -c ":Grep $argv"
  end
end
