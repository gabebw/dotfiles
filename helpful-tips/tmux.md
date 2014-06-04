# Tmux tips

## Copy/paste

It works like in Vim:

* `<PREFIX>-[` to enter copy mode
* `v` to start copying
* `y` to copy and exit copy mode

Now it's in the OSX global pasteboard (because of the
`reattach-to-user-namespace` package), so you can do `Cmd-v` or `pbpaste`.

## Choose sessions from a dropdown

`C-a s` will run `tmux choose-session`, which gives you a browseable list of all
sessions.

## A long list of tips

https://gist.github.com/andreyvit/2921703
