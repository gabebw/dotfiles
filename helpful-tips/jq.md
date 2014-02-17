## Get values out of an array of hashes

Given this:

    [{text: 'hello'}, {text: 'there'}]

Run this:

    $ cat json | jq '.[].text'
    "hello"
    "there"

## Pretty-print JSON (with colors!)

Run it through the "no-op" filter, `.`:

    echo $json | jq .
