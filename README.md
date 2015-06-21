# dotfiles

Gabriel Berke-Williams' dotfiles for zsh, ruby, git, and more.

Questions? Comments? Open an issue or tweet @gabebw.

## Prerequisites

* ZSH. To change your default shell to ZSH: `chsh -s $(which zsh) $USER`
* [Homebrew](http://brew.sh/).

## Installation

    $ ./install.sh

It won't touch your existing dotfiles, but will symlink ones that don't exist.
For example, if you have a `~/.zshrc` but no `~/.zshenv`, then the script will
add a symlink from `~/.zshenv` to the `zshenv` in this repo.

## zsh

* Look in `/zshenv`, `/zshrc`, `/zsh/colors.zsh`, `/zsh/completion.zsh`,
  `/zsh/key_bindings.zsh`, `/zsh/navigation.zsh`, `/zsh/options.zsh`,
  `/zsh/path.zsh`, `/zsh/prompt.zsh`
* Turn off all beeping
* Turn off "helpful" command autocorrecting
* Prevent `zsh: no matches found: ...` error
* Since (among others) `$HOME/code` is in my `cdpath` (see `navigation.zsh`),
  and I have `$HOME/code/hello`, I can type `hello` from anywhere to go to
  there.
* The prompt shows the current directory, the current git branch, the status of
  the git branch (changed, staged, clean, etc) and the current Ruby version
* The prompt is fairly well documented, and is self-contained: you can copy it
  into your dotfiles with no changes to test it out. It's in
  [zsh/prompt.zsh][zsh-prompt].
* Enables pretty colors
* Enables completions
* Enables Vi-style editing on the command line, with `Ctrl-r` to search
  backwards
* If you've typed `abc` then press the Up arrow, it searches for commands
  starting with `abc`; same for the Down arrow.
* Completion for the following commands (in `/zsh/completion-scripts`): `brew`,
  `rake`, `rspec`, `tmux`, `bundle`
* Every time a directory changes, save it to a file and go back to the current
  directory when the shell is opened again. Files are named based on the current
  tmux session.

[zsh-prompt]: /zsh/prompt.zsh

## ruby

Check out `/zsh/ruby.zsh`.

* alias `irb` to `pry`
* `be` is `bundle exec`
* `b` with no arguments runs a faster version of `bundle install` and then
  installs binstubs.
* `b` with arguments (like `b install`) acts just like `bundle`
* `binstubs` installs bundler binstubs to `./bin/stubs`

## rails

Check out `/zsh/rails.zsh`.

* alias `h` to `heroku`
* alias `summer` to `spring stop`
* `rrg something` greps the routes for `something`
* `f` starts `foreman` on the port specified in `.foreman`, or if that's in
  use, starts `foreman` on a guaranteed-unused port.
* `db-reset` drops and resets the database

## Vim

* For Vim-plugin-specific settings, check out `/vim/rcplugins/`.
