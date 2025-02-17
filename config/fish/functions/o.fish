# Use a prefix (`__o_`) because functions are always global, even when defined
# inside other functions: https://github.com/fish-shell/fish-shell/issues/1799

function __o_custom_fd
  command fd --no-ignore --type file $argv
end

function __o_all_images_in_directory -a directory
  __o_custom_fd \
    -e jpg -e png -e jpeg -e webp -a \
    --base-directory $directory \
    $argv[2..-1]
end

function __o_open_images_in_directory -a directory
  # `--max-depth 1` means "only go 1 level inside the directory and don't recurse"
  if __o_all_images_in_directory $directory -q
    open -a Preview (__o_all_images_in_directory $directory | sort)
  end
end

# This will recurse infinitely into the directory you give it, so just do `o
# toplevel/` instead of `o toplevel/**/*.*`.
function o
  if [ (count $argv) -eq 0 ]
    o $PWD
  else
    set -f files_to_open

    for x in $argv
      set -l index (contains -i $x $argv)
      if [ -f $x ]
        set files_to_open $files_to_open $x
      end
    end

    for x in $files_to_open
      set -l index (contains -i $x $argv)
      # Remove it from $argv so it's not processed below
      set -e argv[$index]
    end

    if [ (count $files_to_open) -gt 0 ]
      open $files_to_open
    end

    # Search all dirs at once so we start with the first item of all combined
    # dirs, rather than opening batch 1, then going to the first item in
    # batch 2, and so on
    set -f search_path_all_dirs

    for directory in $argv
      if [ -d $directory ]
        set search_path_all_dirs $teststring --search-path $directory
      end
    end

    if [ (count $search_path_all_dirs) -eq 0 ]
      return 0
    end

    # "-X <command>" means the results are concatenated and the command is
    # executed once with all found results.
    __o_custom_fd \
      -e mp4 -e flv -e mov -e webm -e m4v \
      $search_path_all_dirs \
      -X open

    for directory in $argv
      __o_open_images_in_directory $directory
    end
  end
end
