# Run in dotfiles repo
function sort-vscode-settings
  set -f f "./Library/Application Support/Code/User/settings.json"
  # Ensure that it's valid JSON before we write to it, because that clears the
  # file
  if jq < "$f" > /dev/null
    jq --sort-keys < "$f" | sponge "$f"
  end
end
