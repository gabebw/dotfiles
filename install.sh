#!/bin/bash

# Interactively link dotfiles into ~
./link-dotfiles.sh

# Install Homebrew package
brew bundle

# Install Vim packages
git clone https://github.com/gmarik/vundle.git ./vim/bundle/vundle
vim +BundleInstall +qa
