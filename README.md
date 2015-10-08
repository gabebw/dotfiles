# dotfiles

![prompt](https://cloud.githubusercontent.com/assets/257678/10357733/7304816e-6d3a-11e5-98d6-010cd3fc38d4.png)

Gabriel Berke-Williams' dotfiles for zsh, ruby, git, and more.

Questions? Comments? Open an issue or tweet [@gabebw](https://twitter.com/gabebw).

## Prerequisites

* OS X
* ZSH (to change your default shell to ZSH: `chsh -s $(which zsh) $USER`)
* [Homebrew](http://brew.sh/)

## Installation

    $ git clone git@github.com:gabebw/dotfiles.git ~/.dotfiles
    $ cd ~/.dotfiles
    $ ./install.sh

It will safely symlink the dotfiles, prompting you if a file already exists
(like if you already have `~/.zshrc`).

## zsh

Lots of good stuff in `zsh/options.zsh` and `zsh/aliases.zsh`.

The prompt shows the current directory, the current git branch, the status of
the git branch (changed, staged, clean, etc) and the current Ruby version.  It
is well-documented, and entirely self-contained: you can copy it into your
dotfiles with no changes to test it out. It's in [zsh/prompt.zsh][zsh-prompt].
(It does assume you use rbenv.)

[zsh-prompt]: /zsh/prompt.zsh

## Ruby

Check out `tag-ruby/`, which has zsh and vim configuration.

## tmux

Check out `tag-tmux/`.

## Haskell

Check out `tag-haskell/`.
