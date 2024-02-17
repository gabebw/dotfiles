# With no arguments: "git checkout [main | master]"
# With arguments: "git commit" with the arguments as the message
function gcm
  if [ (count $argv) -eq 0 ]
    git master-to-main-wrapper checkout %BRANCH%
  else
    set -f branch (git current-branch)
    set -f commit_message (string join ' ' $argv)
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
