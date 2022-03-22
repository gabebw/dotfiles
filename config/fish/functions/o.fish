function o -a directory
  function custom_fd; command fd --no-ignore --type file $argv; end
  function open_images_in_directory
      # `--max-depth 1` means "only go 1 level inside the directory and don't recurse"
      custom_fd \
        -e jpg -e png -e jpeg \
        --base-directory $argv[1] \
        -X open -a Preview
  end

  if set -q directory && [ -d "$directory" ]
    if command fd -e mp4 -e flv -e mov -q --base-directory $directory
      # "-X <command>" means the results are concatenated and the command is
      # executed once with all found results.
      custom_fd \
        -e mp4 -e flv -e mov \
        --base-directory $directory \
        -X open
    else
      open_images_in_directory $directory
    end
  else
    if [ (count $argv) -eq 0 ]
      # Are there any images in this directory?
      if [ (count *.{png,jpg}) -gt 0 ]
        open_images_in_directory .
      else
        open *.*
      end
    else
      open $argv
    end
  end
end
