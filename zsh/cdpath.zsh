# Use lowercase `cdpath` because uppercase `CDPATH` can't be set to an array
cdpath=($HOME/code $HOME/code/* $HOME/code/thoughtbot/*)

# Exporting $CDPATH is bad:
# https://bosker.wordpress.com/2012/02/12/bash-scripters-beware-of-the-cdpath/
# So, export PROJECT_DIRECTORIES instead, but set it to $CDPATH
export PROJECT_DIRECTORIES=$CDPATH
