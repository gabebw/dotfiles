# Run in dotfiles repo
function sort-vscode-settings
  set -f f "./Library/Application Support/Code/User/settings.json"
  jq --sort-keys < "$f" | sponge "$f"
end
