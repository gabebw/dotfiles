# Use a prefix (`__o_`) because functions are always global, even when defined
# inside other functions: https://github.com/fish-shell/fish-shell/issues/1799

function __o_custom_fd
  command fd --no-ignore --type file $argv
end

function __o_open_images_in_directory -a directory
  if [ -d /Applications/qView.app ]
    # Just pass all of the arguments to qView, it can handle it
    open -a qView $argv
  else
    echo 'Try installing qView: brew install qview' >&2
    # `--max-depth 1` means "only go 1 level inside the directory and don't recurse"
    open -a Preview (__o_custom_fd \
      -e jpg -e png -e jpeg \
      -a \
      --base-directory $directory | sort)
  end
end

# This will recurse infinitely into the directory you give it, so just do `o
# toplevel/` instead of `o toplevel/**/*.*`.
function o -a directory
  if set -q directory && [ -d "$directory" ]
    if command fd -e webm -e mp4 -e m4v -e flv -e mov -q --base-directory $directory
      # "-X <command>" means the results are concatenated and the command is
      # executed once with all found results.
      custom_fd \
        -e mp4 -e flv -e mov -e webm -e m4v \
        --base-directory $directory \
        -X open
    else
      __o_open_images_in_directory $argv
    end
  else
    if [ (count $argv) -eq 0 ]
      # Are there any images in this directory?
      if [ (count *.{png,jpg}) -gt 0 ]
        __o_open_images_in_directory .
      else
        o $PWD
      end
    else
      open $argv
    end
  end
end
