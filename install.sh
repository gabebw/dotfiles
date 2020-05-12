#!/bin/bash

set -e

yellow() {
  tput setaf 3
  echo "$*"
  tput sgr0
}

info(){
  echo
  yellow "$@"
}

quietly_brew_bundle(){
  brew bundle --file="$1" | grep -vE '^(Using |Homebrew Bundle complete)'
}

info "Checking for command-line tools..."
if ! command -v xcodebuild > /dev/null; then
  xcode-select --install
fi

info "Installing Homebrew if not already installed..."
if ! command -v brew > /dev/null; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

info "Installing Homebrew packages..."
brew tap homebrew/bundle
for brewfile in Brewfile */Brewfile; do
  quietly_brew_bundle "$brewfile"
done
# Brewfile.casks exits 1 sometimes but didn't actually fail
quietly_brew_bundle Brewfile.casks || true

info "Installing rust..."
rustup-init

info "Installing lister..."
cargo install --git https://github.com/gabebw/rust-lister

info "Installing Firefox open URL printer..."
cargo install --git https://github.com/gabebw/rust-firefox-all-open-urls

if ! echo "$SHELL" | grep -Fq zsh; then
  info "Your shell is not Zsh. Changing it to Zsh..."
  chsh -s /bin/zsh
fi

info "Linking dotfiles into ~..."
# Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
# We need the rcrc because it tells `rcup` to ignore thousands of useless Vim
# backup files that slow it down significantly.
RCRC=rcrc rcup -d .

info "Installing Vim packages..."
vim +PlugInstall +qa

info "If you like what you see in system/osx-settings, run ./system/osx-settings"
info "If you're using Terminal.app, check out the terminal-themes directory"

# Installs to ~/.terminfo
echo "Installing italics-capable terminfo files..."
if ! [[ -r ~/.terminfo/61/alacritty ]]; then
  alacritty_terminfo=$(mktemp)
  curl -o "$alacritty_terminfo" https://raw.githubusercontent.com/jwilm/alacritty/master/extra/alacritty.info
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

asdf install
