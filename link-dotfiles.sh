#!/bin/sh

nothing_to_do="true"

for name in *; do
  target="$HOME/.$name"
  if [ ! -L "$target" ]; then
    if [ "$name" != "install.sh" -a "$name" != "link-dotfiles.sh" ]; then
      nothing_to_do=false
      echo "Creating $target"
      ln -s "$PWD/$name" "$target"
    fi
  fi
done

[ $nothing_to_do == "true" ] && echo "Nothing to do."
