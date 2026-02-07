#!/usr/bin/env fish

set repo_folder_name maple-font-repo
function clone_unless_exists
  if [ -d $repo_folder_name ]
    return 0
  else
    git clone https://github.com/subframe7536/maple-font ./$repo_folder_name --depth 1 -b variable
  end
end

# To find out what these flags mean, check out the playground.
# https://font.subf.dev/en/playground/
# Then click "Generate config" to see the CLI flags.
set flags "cv02,cv07,cv64"

if ! gum confirm --default=no "Have you removed the existing Maple Mono fonts in Font Book?"
  gum log --level=warn "ok go do that then come back here"
  exit 1
end

pushd (status dirname)

and clone_unless_exists
and pushd $repo_folder_name
  and uv run build.py --feat $flags --ttf-only
  # "NF" = "Nerd Fonts"
  and mv -v ./fonts/NF/*.ttf ../font-files/
  and open ../font-files/*
popd

popd
