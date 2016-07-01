#!/bin/sh

set -e

echo "Installing Homebrew packages..."
brew update
brew tap homebrew/bundle
brew bundle
for brewfile in */Brewfile; do
  brew bundle --file="$brewfile"
done
brew unlink qt 2>/dev/null || true
brew link --force qt55

echo "Linking dotfiles into ~..."
# Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
# We need the rcrc because it tells `rcup` to ignore thousands of useless Vim
# backup files that slow it down significantly.
RCRC=rcrc rcup -v

echo "Installing Vim packages..."
vim +PlugInstall +qa

echo
echo "If you like what you see in system/osx-settings, run ./system/osx-settings"
echo "If you're using Terminal.app, check out the terminal-themes directory"

for setup in tag-*/setup; do
  . "$setup"
done
