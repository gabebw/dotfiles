# jq -- sed for JSON
{:data-section="shell"}
{:data-date="April 15, 2019"}
{:data-extra="Um Pages"}

## FIND VALUES IN ARRAY OF HASHES

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

## PRETTY-PRINT (WITH COLOR)

Run it through the "no-op" filter, `.`:

    echo $json | jq .

## GET KEYS

    echo $json | jq 'keys'

Or to get keys as part of a jq expression:

    echo $json | jq '.users | keys'
