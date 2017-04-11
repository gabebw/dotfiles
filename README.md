# dotfiles

Gabriel Berke-Williams' dotfiles for Zsh, ruby, git, and more.

They assume you're using OSX.

Questions? Comments? Open an issue or tweet [@gabebw](https://twitter.com/gabebw).

## Installation

    $ git clone git@github.com:gabebw/dotfiles.git ~/.dotfiles
    $ cd ~/.dotfiles
    $ ./install.sh

It will install [rcm] and use that to safely symlink the dotfiles, prompting you
if a file already exists (like if you already have `~/.zshrc`).

[rcm]: http://thoughtbot.github.io/rcm/rcm.7.html

## Organization

`rcm` will symlink all files into place, keeping the folder structure relative
to the tag root. However, non-configuration files and folders like `system/`,
`Brewfile`, `README.md`, etc will not be linked because they are in the
`EXCLUDES` section of the [`rcrc`](/rcrc) file.

## Tags

`rcm` has the concept of tags: items under `tag-git/` are in the `git` tag, and
so on. I'm using it for organization, so that if someone starts using Haskell I
can point them at all of my Haskell configuration across Vim/Zsh/GHCi, all in
one place.

## Zsh

All of the Zsh configuration is in [`zshrc`](/zshrc).

## Attribution

Many scripts and configurations have been inspired by or outright stolen from
my colleagues at thoughtbot. Of special note, I've stolen many things from
[Chris Toomey] and [Gordon Fontenot], among others that I'm sure I'm forgetting.

[Chris Toomey]: https://github.com/christoomey/dotfiles
[Gordon Fontenot]: https://github.com/gfontenot/dotfiles
