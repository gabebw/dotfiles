#!/bin/bash
# vim: set tw=0

set -eo pipefail

green() {
  tput setaf 2
  echo "$*"
  tput sgr0
}

yellow() {
  tput setaf 3
  echo "$*"
  tput sgr0
}

info(){
  green "=== $@"
}

stay_awake_while(){
  caffeinate -dims "$@"
}

quietly_brew_bundle(){
  local regex='(^Using )|Homebrew Bundle complete|Skipping install of|It is not currently installed'
  stay_awake_while brew bundle --verbose --file="$1" | (grep -vE "$regex" || true)
}

command_does_not_exist(){
  ! command -v "$1" > /dev/null
}

info "Checking for command-line tools..."
if command_does_not_exist xcodebuild; then
  stay_awake_while xcode-select --install
fi

info "Installing Homebrew (if not already installed)..."
if command_does_not_exist brew; then
  stay_awake_while /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

info "Installing Homebrew packages..."
brew tap homebrew/bundle
for brewfile in Brewfile */Brewfile; do
  quietly_brew_bundle "$brewfile"
done
# Brewfile.casks exits 1 sometimes but didn't actually fail
quietly_brew_bundle Brewfile.casks || true
# Pin postgresql since I use Postgres.app and we only need it as a dependency
brew pin postgresql

info "Installing rust..."
stay_awake_while rustup-init -y > /dev/null

info "Installing lister..."
if command_does_not_exist lister; then
  stay_awake_while cargo install --git https://github.com/gabebw/rust-lister
fi

info "Installing Firefox open URL printer..."
if command_does_not_exist firefox-all-open-urls; then
  stay_awake_while cargo install --git https://github.com/gabebw/rust-firefox-all-open-urls
fi

if ! echo "$SHELL" | grep -Fq zsh; then
  info "Your shell is not Zsh. Changing it to Zsh..."
  chsh -s /bin/zsh
fi

info "Linking dotfiles into ~..."
# Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
# We need the rcrc because it tells `rcup` to ignore thousands of useless Vim
# backup files that slow it down significantly.
stay_awake_while RCRC=rcrc rcup -d .

info "Installing Vim packages..."
vim +PlugInstall +qa

info "Creating ~/Desktop/screenshots so screenshots can be saved there..."
mkdir -p ~/Desktop/screenshots

stay_awake_while ./system/osx-settings

# Installs to ~/.terminfo
echo "Installing italics-capable terminfo files..."
if ! [[ -r ~/.terminfo/61/alacritty ]]; then
  alacritty_terminfo=$(mktemp)
  stay_awake_while curl -o "$alacritty_terminfo" https://raw.githubusercontent.com/jwilm/alacritty/master/extra/alacritty.info
  tic -xe alacritty,alacritty-direct "$alacritty_terminfo"
fi

# Load asdf (before setup scripts) in case it's the first time installing it
export NODEJS_CHECK_SIGNATURES=no
source /usr/local/opt/asdf/asdf.sh

info "Running all setup scripts..."
for setup in tag-*/setup; do
  dir=$(basename "$(dirname "$setup")")
  info "Running setup for ${dir#tag-}..."
  . "$setup"
done

stay_awake_while asdf install

green "== Success!"
