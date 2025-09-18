# With no arguments: "git checkout [main | master]"
# With arguments: "git commit" with the arguments as the message
function gcm
  set -l COMMIT_PREFIX_FILENAME ".commit-prefix"
  set -l COMMIT_PREFIX_FILE_PATH (git rev-parse --show-toplevel)/$COMMIT_PREFIX_FILENAME

  if [ (count $argv) -eq 0 ]
    git master-to-main-wrapper checkout %BRANCH%
  else
    set -f branch (git current-branch)
    set -f commit_message (string join ' ' $argv)
    if [ -r $COMMIT_PREFIX_FILE_PATH ]
      set -l commit_prefix  (cat $COMMIT_PREFIX_FILE_PATH | tr -d '\n' | string trim)
      set commit_message "$commit_prefix $commit_message"
    end

    echo $commit_message
    set -f commit_message_length (string length $commit_message)
    if [ $commit_message_length -gt 50 ]
      echo "Commit message length ($commit_message_length) > 50, not committing" >&2
      return 1
    else
      git commit -m $commit_message
    end
  end
end
