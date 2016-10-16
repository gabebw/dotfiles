has_subdirs(){
  if [[ -d "$1" ]]; then
    [[ "$(find "$1" -type d -maxdepth 0 -empty -exec echo -n empty \;)" != "empty" ]]
  else
    return 1
  fi
}

add_dir_to_cdpath(){
  if [ -d "$1" ]; then
    # Use lowercase `cdpath` because uppercase `CDPATH` can't be set to an array
    cdpath+=("$1")
  fi
}

add_subdirs_to_cdpath(){
  if has_subdirs "$1"; then
    for subdir in "$1"/*; do
      cdpath+=("$subdir")
    done
  fi
}

add_dir_to_cdpath "$HOME/code"
add_subdirs_to_cdpath "$HOME/code"
add_subdirs_to_cdpath "$HOME/code/thoughtbot"

# Exporting $CDPATH is bad:
# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/
# So, export PROJECT_DIRECTORIES instead, but set it to $CDPATH
export PROJECT_DIRECTORIES=$CDPATH
