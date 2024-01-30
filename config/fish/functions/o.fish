# Use a prefix (`__o_`) because functions are always global, even when defined
# inside other functions: https://github.com/fish-shell/fish-shell/issues/1799

function __o_custom_fd
  command fd --no-ignore --type file $argv
end

function __o_all_images_in_directory
  set directory $argv[1]
  set --erase argv[1]
  __o_custom_fd -e jpg -e png -e jpeg -a --base-directory $directory $argv
end

function __o_open_images_in_directory -a directory
  # `--max-depth 1` means "only go 1 level inside the directory and don't recurse"
  if __o_all_images_in_directory $directory -q
    open -a Preview (__o_all_images_in_directory $directory | sort)
  end
end

# This will recurse infinitely into the directory you give it, so just do `o
# toplevel/` instead of `o toplevel/**/*.*`.
function o -a directory
  if set -q directory && [ -d "$directory" ]
    # "-X <command>" means the results are concatenated and the command is
    # executed once with all found results.
    __o_custom_fd \
      -e mp4 -e flv -e mov -e webm -e m4v \
      --base-directory $directory \
      -X open
    __o_open_images_in_directory $directory
  else
    if [ (count $argv) -eq 0 ]
      o $PWD
    else
      open $argv
    end
  end
end
