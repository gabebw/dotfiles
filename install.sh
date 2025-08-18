#!/bin/bash
# vim: tw=0

set -eo pipefail

color() {
  local colornumber="$1"
  shift
  tput setaf "$colornumber"
  echo "$*"
  tput sgr0
}

# blue = 4
# magenta = 5
red(){ color 1 "$*"; }
green(){ color 2 "$*"; }
yellow(){ color 3 "$*"; }

info(){
  green "=== $*"
}

error(){
  red "!! $*" >&2
}

stay_awake_while(){
  caffeinate -dims "$@"
}

quietly_brew_bundle(){
  local brewfile=$1
  shift
  local regex='(^Using )|Homebrew Bundle complete|Skipping install of|It is not currently installed|Verifying SHA-256|==> (Downloading|Purging)|Already downloaded:|No SHA-256'
  stay_awake_while brew bundle --file="$brewfile" "$@" | (grep -vE "$regex" || true)
}

command_does_not_exist(){
  ! command -v "$1" > /dev/null
}

make_qlstephen_work_on_catalina(){
  xattr -cr ~/Library/QuickLook/QLStephen.qlgenerator
  qlmanage -r
  qlmanage -r cache
  killall Finder
}

info "Checking for command-line tools..."
if command_does_not_exist xcodebuild; then
  stay_awake_while xcode-select --install
fi

info "Installing Homebrew (if not already installed)..."
if command_does_not_exist brew; then
  stay_awake_while /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Don't run `brew cleanup <package>` after each package is installed. It just makes things take longer.
export HOMEBREW_NO_INSTALL_CLEANUP=1
eval "$(/opt/homebrew/bin/brew shellenv)"

info "Installing Homebrew packages..."
for brewfile in Brewfile */Brewfile; do
  quietly_brew_bundle "$brewfile" --verbose
done

# Brewfile.casks exits 1 sometimes but didn't actually fail
quietly_brew_bundle Brewfile.casks || true
# Pin postgresql since I use Postgres.app and we only need it as a dependency
brew pin postgresql@14

make_qlstephen_work_on_catalina

info "Installing rust..."
stay_awake_while rustup-init --no-modify-path -y > /dev/null
# Make sure `cargo` is in $PATH
source "$HOME/.cargo/env"
rustup component add clippy

info "Installing lister..."
if command_does_not_exist lister; then
  stay_awake_while cargo install --git https://github.com/gabebw/rust-lister
fi

info "Installing Firefox open URL printer..."
if command_does_not_exist firefox-all-open-urls; then
  stay_awake_while cargo install --git https://github.com/gabebw/rust-firefox-all-open-urls
fi

if ! echo "$SHELL" | grep -Fq fish; then
  info "Your shell is not Fish. Changing it to Fish..."
  # Fix this error when running `chsh`:
  # chsh: /usr/local/bin/fish: non-standard shell
  which fish | sudo tee -a /etc/shells > /dev/null

  # Now check if it worked
  if ! grep -Fq "$(which fish)" /etc/shells; then
    error "Sorry, fish is not (YET) an approved shell"
    error "I tried to add it automatically but it didn't work."
    error "Please manually add this line to /etc/shells: $(which fish)"
    exit 1
  fi

  chsh -s "$(which fish)"
fi

info "Linking dotfiles into ~..."
# Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
# We need the rcrc because it tells `rcup` to ignore thousands of useless Vim
# backup files that slow it down significantly.
export RCRC=rcrc
stay_awake_while rcup -d .

info "Installing Neovim packages..."
nvim +qa

stay_awake_while ./system/osx-settings

if command -v asdf &>/dev/null || [[ -d ~/.asdf ]]; then
  echo 'Removing asdf...'

  rm -rf ~/.asdf || true
  brew uninstall asdf || true
fi

# Load mise (before setup scripts) in case it's the first time installing them
eval (mise activate)

info "Running all setup scripts..."
for setup in tag-*/setup vscode/setup; do
  dir=$(basename "$(dirname "$setup")")
  info "Running setup for ${dir#tag-}..."
  . "$setup"
done

mkdir -p ~/code/work
mkdir -p ~/code/personal
mkdir -p ~/code/src

green "== Success!"

yellow "== Post-install instructions =="
yellow "1. Remap Caps Lock to Escape in the Keyboard prefpane"
yellow "2. Set up top right Hot Corner -> Desktop in Desktop & Screen Saver prefpane"
