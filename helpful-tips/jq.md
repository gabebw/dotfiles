## Get values out of an array of hashes

Given this:

    [{text: 'hello'}, {text: 'there'}]

Run this:

    $ cat json | jq '.[].text'
    "hello"
    "there"

Or given this:

    {key: [{id: 1}, {id: 2}]}

To get the IDs:

    $ cat json | jq '.key[].id'
    "1"
    "2"

## Pretty-print JSON (with colors!)

Run it through the "no-op" filter, `.`:

    echo $json | jq .

