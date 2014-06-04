How do I change my shell to ZSH?

    chsh -s /bin/zsh

Where can I find awesome 'zshrc's?

http://dotfiles.org/.zshrc (and check out the rest of the site too)

Search backward through history: Ctrl-R

Modify the most recent command:

    r search=replace
    # example
    $ mkdir my_dir
    $ r mkdir=cd # this runs "cd my_dir"

Open an editor ($EDITOR) to edit the last command:

    fc

Print an ASCII calendar:

    cal # or ncal

hashing: hash -d HASH=directory, then "cd ~HASH"
- Do not use ~ in the directory, either. Use /Users/gabe/.
- more info: http://michael-prokop.at/blog/2008/12/01/mikas-advent-calendar-day-1/

How do I unset a function?

    unfunction <function-name>

How do I do a named hexdump, with "nul" instead of hexdump -C's "0"?

    # Also: man od
    od -a

How do I re-initialize my PATH, so that newly-installed programs show up for autocomplete?

    export PATH=$PATH
    # as a function
    function reinitialize { export PATH=$PATH }


You can also use an alias, though I'd recommend against it: `alias
reinitialize="export PATH=$PATH"`. The alias will be expanded when you source
the file with the alias, but in this case that doesn't matter since you want
to set it to that same value anyway.  Of course, if you've modified your
path since that source time, then the alias will remove those modifications.
Long story short: go with the function.

## Completion
How do I make compinit (`autoload compinit && compinit`) find the directory where I store my completion scripts?
compinit searches the $fpath array of directories. Simply add your directory via:

    fpath=(/my/completion/directory $fpath)

How do I complete one command like another command?

    # complete `g` like `git`
    compdef g=git

## zstyle

How do I delete all zstyle settings?

    zstyle -d

For more on style, see [the ZSH docs](http://zsh.sourceforge.net/Doc/Release/zsh_21.html#SEC182).

## Options

Use via e.g. `setopt correct` or `unsetopt correct`

`correct`: correct commands
`correctall`: correct commmands AND arguments
`hist_reduce_blanks`: Removes meaningless whitespace in previous commands, so
  `echo 'asdf 1234'    ` shows up as `echo 'asdf 1234'` when you press <UP> to
  go back in history
`hist_ignore_all_dups`: don't store repeated commands
`autocd`: type a directory name to cd to it, no need to type out "cd"
`prompt_subst`: allow commands in prompt, so you can do
  PS1="%{my_function%}" and it'll work.

## ZSH Variables

`SAVEHIST`: The maximum number of history events to save in the history file.
`HISTSIZE`: The maximum number of events stored in the internal history list. If
  you use the `HIST_EXPIRE_DUPS_FIRST` option, setting this value larger than
  the `SAVEHIST` size will give you the difference as a cushion for saving
  duplicated history events. (i.e., SAVEHIST will then be the number of unique
  events to save)

## VCS info (mostly git)

First do `autoload -Uz vcs_info`.

Try these articles:

* http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
* http://kriener.org/articles/2009/06/04/zsh-prompt-magic
