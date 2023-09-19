# With no arguments: "git checkout [main | master]"
# With arguments: "git commit" with the arguments as the message
function gcm
  if [ (count $argv) -eq 0 ]
    git master-to-main-wrapper checkout %BRANCH%
  else
    set -f branch (git current-branch)
    set -f commit_message (string join ' ' $argv)
    # Grab JIRA ticket name (if any) and prefix it to the commit.
    if not string match -q 'cheetah-web' (basename $PWD)
      if string match -qr '^(?<ticket_number>[A-Z]{2,}-[0-9]+)' $branch
        # The magic "$ticket_number" variable now contains the named group
        set commit_message "$ticket_number $commit_message"
      end
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
