# Search for files in current directory
# Breaks (shows zero results no matter what) if the current directory is
# excluded in Spotlight privacy preferences, because this function relies on
# `mdfind`.
function search_spotlight_files -a term
  # `-onlyin .` will recurse
  mdfind -onlyin . $term | sort | rg -v '\.(part|download|epub)$'
end
