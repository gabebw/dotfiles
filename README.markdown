# gabebw's dotfiles
These are my dotfiles: `~/.*`

As you may notice, they aren't actually dotfiles - they don't have a dot in
front! To interactively link them into ~, run
`rake link:all`

The Rakefile has following tasks:
```bash
    rake default             # Install everything and link dotfiles
    rake install:all         # Install RVM, Homebrew, and useful Homebrew formulae
    rake install:brews       # Install some useful homebrew formulae
    rake install:homebrew    # Install homebrew
    rake install:rvm         # Install RVM
    rake install:slime       # Install SLIME, a good Lisp mode for Emacs
    rake link:all            # Link all dotfiles into ~
    rake uninstall:all       # Uninstall everything
    rake uninstall:homebrew  # Uninstall homebrew
    rake uninstall:rvm       # Uninstall RVM
    rake update:slime        # Update SLIME
    rake update:vim_plugins  # Update vim plugins
```
