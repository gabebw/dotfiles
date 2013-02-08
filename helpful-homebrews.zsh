#!/usr/bin/env zsh

# Run this script to install some helpful (but not essential) programs.

function info(){
  echo
  echo
  echo
  echo $*
}

info "Installing jq, sed for json..."
  brew install jq

info "Installing pgrep, grep for ps..."
  brew install pgrep

info "Installing heroku-toolbelt, the recommended way to use Heroku..."
  brew install heroku-toolbelt

info "Installing rbenv, a lovely Ruby version manager..."
  brew install rbenv

info "Installing ruby-build to get 'rbenv install'..."
  brew install ruby-build

info "Installing colordiff to get colorful diffs (alias diff='colordiff -u')..."
  brew install colordiff

info "Installing ag, a better ack/grep..."
  brew install the_silver_searcher

info "Installing tmux, a terminal multiplexer..."
  brew install tmux

info "Installing tmux, a terminal multiplexer..."
  brew install tmux

info "Installing reattach-to-user-namespace so copy/paste works in tmux..."
  brew install reattach-to-user-namespace

info "Installing ctags so :Rtags works..."
  brew install ctags

info "Installing Vim..."
  brew install mercurial vim

info "Installing rbenv-gem-rehash so you never have to rehash..."
  brew install rbenv-gem-rehash

info "Installing rbenv-vars so you can set per-project vars..."
  brew install rbenv-vars
