# Use lowercase `cdpath` because uppercase `CDPATH` can't be set to an array
for dir in $HOME/code $HOME/code/* $HOME/code/thoughtbot/*; do
  if [ -d "$dir" ]; then
    cdpath+=("$d")
  fi
done

# Exporting $CDPATH is bad:
# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/
# So, export PROJECT_DIRECTORIES instead, but set it to $CDPATH
export PROJECT_DIRECTORIES=$CDPATH
