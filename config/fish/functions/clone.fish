# Clone and start a new tmux session about it
function clone -a directory github_repo repo_name
  if [ (count $argv) -lt 2 ]
    echo "Please provide a directory and a repo name" >&2
    echo "You can also provide an optional name for the local directory" >&2
    echo "Usage: clone personal gabebw/dotfiles [gabebw-dotfiles]" >&2
    return 1
  end
  pushd $directory
  if gcl $argv
    # Name the session after the current directory
    set -f session_name (basename $PWD)
    if tmux-session-exists $session_name
      set -f session_name (string join '-' $session_name "new")
    end
    tcd $PWD $session_name
    popd
  end
  popd
end
