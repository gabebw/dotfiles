#!/bin/sh

echo "Interactively linking dotfiles into ~..."
./link-dotfiles.sh

echo "Installing Homebrew packages..."
brew update
awk '/^[^#]/ { print $2 }' Brewfile | xargs brew install

echo "Installing latest Ruby..."
rbenv install 2.1.2

echo "Installing Vim packages..."
git clone git@github.com:gmarik/Vundle.vim.git ./vim/bundle/Vundle.vim
vim +PluginInstall +qa

echo "If you like what you see in system/osx-settings, run ./system/osx-settings"
echo "If you're using Terminal.app, check out the terminal-themes directory"
