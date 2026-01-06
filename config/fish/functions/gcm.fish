# With no arguments: "git checkout [main | master]"
# With arguments: "git commit" with the arguments as the message
function gcm
  set -l COMMIT_PREFIX_FILENAME ".commit-prefix"
  set -l COMMIT_PREFIX_FILE_PATH (git rev-parse --show-toplevel)/$COMMIT_PREFIX_FILENAME
  set -l MAX_LENGTH 50

  if [ (count $argv) -eq 0 ]
    git master-to-main-wrapper checkout %BRANCH%
  else
    set -f branch (git current-branch)
    set -f commit_message (string join ' ' $argv)
    if [ -r $COMMIT_PREFIX_FILE_PATH ]
      set -l commit_prefix  (cat $COMMIT_PREFIX_FILE_PATH | tr -d '\n' | string trim)
      set commit_message "$commit_prefix $commit_message"
    end

    set -f commit_message_length (string length $commit_message)
    if [ $commit_message_length -gt $MAX_LENGTH ] && ! string match -qr '^WIP' $commit_message
      set_color red
      echo >&2
      echo $commit_message >&2
      echo >&2
      echo "!!! Commit message length ($commit_message_length) > $MAX_LENGTH, not committing" >&2
      echo >&2
      return 1
    else
      echo $commit_message
      git commit -m $commit_message
    end
  end
end
