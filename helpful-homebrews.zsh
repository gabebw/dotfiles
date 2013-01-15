#!/usr/bin/env zsh

# Run this script to install some helpful (but not essential) programs.

echo "Installing jq, sed for json..."
  brew install jq

echo "Installing pgrep, grep for ps..."
  brew install pgrep

echo "Installing heroku-toolbelt, the recommended way to use Heroku..."
  brew install heroku-toolbelt

echo "Installing rbenv, a lovely Ruby version manager..."
  brew install rbenv

echo "Installing ruby-build to get 'rbenv install'..."
  brew install ruby-build

echo "Installing colordiff to get colorful diffs (alias diff='colordiff -u')..."
  brew install colordiff

echo "Installing ag, a better ack/grep..."
  brew install the_silver_searcher
