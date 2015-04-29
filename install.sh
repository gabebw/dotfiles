#!/bin/sh

latest_ruby_version="2.2.0"

echo "Interactively linking dotfiles into ~..."
./link-dotfiles.sh

echo "Installing Homebrew packages..."
brew update
brew tap homebrew/brewdler
brew brewdle

echo "Installing latest Ruby..."
rbenv install "$latest_ruby_version"

echo "Installing Vim packages..."
git clone git@github.com:gmarik/Vundle.vim.git ./vim/bundle/Vundle.vim
vim +PluginInstall +qa

echo "Disabling non-sandbox cabal installs..."
echo "require-sandbox: True" >> ~/.cabal/config

echo "If you like what you see in system/osx-settings, run ./system/osx-settings"
echo "If you're using Terminal.app, check out the terminal-themes directory"
