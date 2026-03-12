# Print the input, then error
# If there is no input, then do nothing and succeed.
# Usage:
#     something_that_should_be_quiet | error_if_input
#
# `gum` must be installed: `brew install gum`
function error_if_input
  read stdin
  if [ -n "$stdin" ]
    error $stdin
    return 1
  else
    return 0
  end
end

# The top-level directory in this git repo, where `.git` is
function git_root
  git rev-parse --show-toplevel
end

# Time formats that `gum log --time` accepts, with examples:
# (the bit after "WARN" is the format name, e.g. `layout`)
# 03/11 09:55:26PM '26 -0700 WARN layout
# Wed Mar 11 21:55:26 2026 WARN ansic
# Wed Mar 11 21:55:26 PDT 2026 WARN unixdate
# Wed Mar 11 21:55:26 -0700 2026 WARN rubydate
# 11 Mar 26 21:55 PDT WARN rfc822
# 11 Mar 26 21:55 -0700 WARN rfc822z
# Wednesday, 11-Mar-26 21:55:26 PDT WARN rfc850
# Wed, 11 Mar 2026 21:55:26 PDT WARN rfc1123
# Wed, 11 Mar 2026 21:55:26 -0700 WARN rfc1123z
# 2026-03-11T21:55:26-07:00 WARN rfc3339
# 2026-03-11T21:55:26.36574-07:00 WARN rfc3339nano
# 9:55PM WARN kitchen
# Mar 11 21:55:26 WARN stamp
# Mar 11 21:55:26.442 WARN stampmilli
# Mar 11 21:55:26.468033 WARN stampmicro
# Mar 11 21:55:26.493943000 WARN stampnano
# 2026-03-11 21:55:26 WARN datetime
# 2026-03-11 WARN dateonly
# 21:55:26 WARN timeonly

function info
  gum log --level=info --time=stamp $argv
end

function warn
  gum log --level=warn --time=stamp $argv
end

function error
  gum log --level=error --time=stamp $argv
end
