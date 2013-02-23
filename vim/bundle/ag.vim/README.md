# ag.vim #

This is an adaptation of Ack.vim to use Ag instead. Ag can be used as a
replacement for 99% of the uses of _grep_.  This plugin will allow you to run
ag from vim, and shows the results in a split window. This plugin is almost copy and pasted from [mileszs' ack.vim plugin](https://github.com/mileszs/ack.vim).


## Installation ##


### Ag

You have to install [ag](https://github.com/ggreer/the_silver_searcher), of course.

Install with Homebrew:

    brew install the_silver_searcher

Otherwise, you are on your own.

### The Plugin

If you have [Rake](http://rake.rubyforge.org/) installed, you can just run: `rake install`.

Otherwise, the file ag.vim goes in ~/.vim/plugin, and the ag.txt file belongs in ~/.vim/doc.  Be sure to run

    :helptags ~/.vim/doc

afterwards.


## Usage ##

    :Ag [options] {pattern} [{directory}]

Search recursively in {directory} (which defaults to the current directory) for the {pattern}.

Files containing the search term will be listed in the split window, along with
the line number of the occurrence, once for each occurrence.  [Enter] on a line
in this window will open the file, and place the cursor on the matching line.

Just like where you use :grep, :grepadd, :lgrep, and :lgrepadd, you can use `:Ag`, `:AgAdd`, `:LAg`, and `:LAgAdd` respectively. (See `doc/ag.txt`, or install and `:h Ag` for more information.)

### Keyboard Shortcuts ###

In the quickfix window, you can use:

    o    to open (same as enter)
    go   to preview file (open but maintain focus on ag.vim results)
    t    to open in new tab
    T    to open in new tab silently
    v    to open in vertical split
    gv   to open in vertical split silently
    q    to close the quickfix window

This plugin is almost copy and pasted from [mileszs' ack.vim plugin](https://github.com/mileszs/ack.vim).
