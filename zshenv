# Vim only sources zshenv (this file), not zshrc.

# Add the Homebrew path here so that Vim can find Homebrew's ctags.
PATH=/usr/local/bin:/usr/local/sbin:$PATH

[[ -r /usr/local/opt/asdf/asdf.sh ]] && . /usr/local/opt/asdf/asdf.sh

if [[ -r ~/.terminfo/61/alacritty ]]; then
  export TERM=alacritty
else
  export TERM=xterm-256color
fi

for dir in /Users/gabe/.asdf/installs/nodejs/*; do
  PATH="${dir}/.npm/bin:$PATH"
done
export PATH
