# Print the input, then error
# If there is no input, then do nothing and succeed
# `gum` must be installed: `brew install gum`
function error
  read stdin
  if [ -n "$stdin" ]
    gum log --level=error $stdin
    return 1
  else
    return 0
  end
end

# The top-level directory in this git repo, where `.git` is
function git_root
  git rev-parse --show-toplevel
end
