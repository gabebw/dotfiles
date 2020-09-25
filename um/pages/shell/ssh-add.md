# ssh-add --
{:data-section="shell"}
{:data-date="September 25, 2020"}

## SYNOPSIS

## TIPS

### To add an SSH key to the OSX keychain

This makes the SSH key persist across reboots, so you don't need to `ssh-add`
after every restart.

    /usr/bin/ssh-add -K ~/.ssh/id_rsa

The `-K` flag is only available in the Apple-provided `ssh-add`, so use the full
path in case there's a Homebrew version of SSH around.

## OPTIONS
