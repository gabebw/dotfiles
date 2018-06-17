# Tmux tips

## Copy/paste

It works like in Vim:

* `<Prefix>-[` to enter copy mode
* `v` to start copying
* `y` to copy and exit copy mode

Now it's in the OSX global pasteboard, so you can do `Cmd-v` or `pbpaste`.

## Choose sessions from a dropdown

`<Prefix> s` will run `tmux choose-session`, which gives you a browseable list of all
sessions.

BUT! `<Prefix> j` (in my dotfiles) will run `tmux choose-tree`, which is like
`choose-session` but also lets you hit Right-Arrow when your cursor is over a
specific session to choose the window that you want to jump to.

## Tmux command prompt

`<Prefix> :` is bound to `tmux command-prompt`, which brings up the tmux command
prompt at the bottom of the window. Enter commands there without the `tmux `, so
`tmux rename-session hello` is now `rename-session hello`.

## A long list of tips

https://gist.github.com/andreyvit/2921703

## Even more tips

http://wiki.gentoo.org/wiki/Tmux#Key_Binds
