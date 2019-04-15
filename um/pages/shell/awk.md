# awk --
{:data-section="shell"}
{:data-date="April 15, 2019"}
{:data-extra="Um Pages"}

## Mimic `grep`

Print lines that match a regex:

    awk '/regex/'

## Mimic `grep -v`

Print lines that _don't_ match a regex:

    awk '!/regex/'

## Mimic `grep` + `grep -v`

Match one regex and don't match another regex, and print matching lines:

    awk '/regex/ && !/other regex/'

## Print the Nth "word"

This is helpful for when you don't want to strip whitespace or worry about
`cut`. Just print the nth thing that looks like a word. It also strips
whitespace from the front and back:

    $ echo " hey " | awk '{ print $1 }'
    hey
    $ echo " hey     there" | awk '{ print $2 }'
    there

No `sed` or `cut` required!
