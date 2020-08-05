# jq -- sed for JSON
{:data-section="shell"}
{:data-date="April 15, 2019"}
{:data-extra="Um Pages"}

## Re-shape an array of hashes

Given this:

    { "topLevel": [ { "sub": "a" }, { "sub": "b" } ] }

To get this:

    [{ "letter": "a" }, { "letter": "b" }]

Do this:

    jq '[ .topLevel[] | { letter: .sub } ]'

## Cast a value to a number with `tonumber`

Given this:

    [{ "price": "40" }, { "price": "25" }]

To get this:

    [{ "price": 40 }, { "price": 25 }]

Do this:

    jq '[.[] | { price: (.price|tonumber) }]'

## Sort by a key

Given this:

    [{ "price": 40 }, { "price": 25 } ]

To sort ascending by price, do this:

    jq 'sort_by(.price)'

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

## RECURSIVE DESCENT

If you have a giant nested JSON blob and don't want to painstakingly figure out
the path to get a specific key, let the `..` operator do it for you:

    curl -A 'ua' https://www.reddit.com/r/food/new.json | jq '..|.permalink?'

## SELECT NON-NULL ITEMS

Pipe to 'select(.)':

    jq 'whatever | goes | here | select(.)'

## PRETTY-PRINT (WITH COLOR)

Run it through the "no-op" filter, `.`:

    echo $json | jq .

## GET KEYS

    echo $json | jq 'keys'

Or to get keys as part of a jq expression:

    echo $json | jq '.users | keys'
