# Play Rdio playlists from Vim

Requirements:

* [fzf][fzf] (`brew install fzf`), with the [Vim plugin][fzf-vim] set up
* fzf requires the `curses` gem

[fzf]: https://github.com/junegunn/fzf
[fzf-vim]: https://github.com/junegunn/fzf#install-as-vim-plugin

## Usage

Run `:Rdio` and you're off.

## Developing

The files in `output` are generated from the `.scpt.in` files, because they
require minified JS that's easier to generate than hand-code.

To re-generate the files in `output`, run `rake`.

