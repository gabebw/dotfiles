#!/bin/bash

# Interactively link dotfiles into ~
./link-dotfiles.sh

# Install Homebrew package
brew bundle

# Install Vim packages
vim +BundleInstall +qa
