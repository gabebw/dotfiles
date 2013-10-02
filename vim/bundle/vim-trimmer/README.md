# vim-trimmer

A super-simple vim plugin that:
* Adds an autocmd that trims trailing whitespace on buffer write while
  preserving cursor position.
* Optionally disables the autocmd for specified blacklisted filetypes (see
  configuration).

## Installation

Use [Vundle][v] and add the following to your `.vimrc`:

```
Bundle 'derekprior/vim-trimmer'
```

Run the `:BundleInstall` command and you're off.

## Configuration
To opt certain filetypes out of the autocommand, add them to the blacklist
array like so: `let g:trimmer_blacklist = ['markdown', 'make']`.

[v]:https://github.com/gmarik/vundle
