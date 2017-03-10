#!/bin/sh

set -e

is_osx(){
  [ "$(uname -s)" = Darwin ]
}

is_linux(){
  [ "$(uname -s)" = Linux ]
}

if is_osx; then
  echo "Checking for Homebrew..."
  if ! command -v brew > /dev/null; then
    echo "Please install Homebrew. Instructions are at https://brew.sh/"
    echo "After you're done, rerun this script."
    exit 1
  fi

  echo "Installing Homebrew packages..."
  brew update
  brew tap homebrew/bundle
  brew bundle
  for brewfile in */Brewfile; do
    brew bundle --file="$brewfile"
  done
fi

if ! echo $SHELL | grep -Fq zsh; then
  echo "Your shell is not Zsh. Changing it to Zsh..."
  chsh -s $(which zsh) $USER
fi

echo "Linking dotfiles into ~..."
# Before `rcup` runs, there is no ~/.rcrc, so we must tell `rcup` where to look.
# We need the rcrc because it tells `rcup` to ignore thousands of useless Vim
# backup files that slow it down significantly.
RCRC=rcrc rcup -v -d .

echo "Installing zsh-syntax-highlighting..."
if [ ! -d ~/.zsh-plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-plugins/zsh-syntax-highlighting
fi

echo "Installing Vim packages..."
vim +PlugInstall +qa

if is_osx; then
  echo
  echo "If you like what you see in system/osx-settings, run ./system/osx-settings"
  echo "If you're using Terminal.app, check out the terminal-themes directory"
fi

for setup in tag-*/setup; do
  . "$setup"
done
