#!/bin/bash

# Interactively link dotfiles into ~
./link-dotfiles.sh

# Install Homebrew package
brew bundle

# Install Vim packages
git clone git@github.com:gmarik/Vundle.vim.git ./vim/bundle/Vundle.vim
vim +BundleInstall +qa

echo "If you like what you see in system/osx-settings, run ./system/osx-settings"
