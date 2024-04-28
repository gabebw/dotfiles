# jq -- sed for JSON
{:data-section="shell"}
{:data-date="April 15, 2019"}
{:data-extra="Um Pages"}

## String interpolation

Given this:

    { "animal": "cat", "sound": "meow" }

To get this:

    cat goes meow

Do this:

    jq --raw-output '"\(.animal) goes \(.sound)"'

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

## FILTER ITEMS FROM AN ARRAY OF OBJECTS

Given something like this:

    [{ name: "Foo", year: "2020" }, { name: "Bar", year: "2021" }]

You can filter to only items with a given year with `select`:

    jq '.[] | select(.time | startswith("2021"))'

Or filter by equality:

    jq '.[] | select(.name == "Foo")'

To filter out non-null items from an array, pipe to 'select(.)':

    jq 'whatever | goes | here | select(.)'

## PRETTY-PRINT (WITH COLOR)

Run it through the "no-op" filter, `.`:

    echo $json | jq .

## GET KEYS

    echo $json | jq 'keys'

Or to get keys as part of a jq expression:

    echo $json | jq '.users | keys'

## SET A VALUE AS A VARIABLE

Add it to the pipeline, and maybe return it at the end if it passes the tests:

    jq "... | .selector.date as $date | ... | $date"

## ONLY RETURN DATA THAT PASSES A TEST

Set the parent to a variable, use recursive descent to test the contents, then
return the parent if it passed the test:

    jq '. as $parent | select(.. | .year? == "2019") | $parent'

## FIND DATA THAT PASSES A TEST

Find an arbitrarily-nested object with a couple of attributes, and find the item
that passes. For example, imagine you have an array of objects and want to find
each one's `date` object that has a year of `2019`:

    jq '.. | select(.. | .year? == "2019")

## FILTER BY STRING MATCH

Find an object with a `.name` key that contains "Gabe" in the string:

    jq 'select(.name | test("Gabe"))'

To ignore case, pass the "i" flag (note the semicolon!):

    jq 'select(.name | test("Gabe"; "i"))'

## RENAME A KEY

...without having to re-specify all of the other keys.

Given this input:

    [
      {
        "type": "dog",
        "name": "Fido",
        "weightInKg": 36.2
      },
      {
        "type": "cat",
        "name": "Whiskers",
        "weightInKg": 4
      }
    ]

Use `with_entries` on a single entry, or `map(with_entries(...))` on an array:

    cat data.json | jq 'map(with_entries(if .key == "type" then .key = "species" else . end))'

## TRANSFORM A NESTED KEY

Given this input:

    [
      {
        "type": "dog",
        "name": "Fido",
        "weightInKg": 36.2,
      },
      {
        "type": "cat",
        "name": "Whiskers",
        "weightInKg": 4,
      }
    ]

Let's say you want their weight in pounds, not kilograms. To transform the
`weightInKg` key without changing any other keys:

    cat data.json | jq '.[].weightInKg |= .*2.205)'

To round the number:

    cat data.json | jq '.[].weightInKg |= (.*2.205 | round)'

To rename the key to `weightInLbs`:

    cat data.json | jq '.[].weightInKg |= (.*2.205 | round)' | map(with_entries(if .key == "weightInKg" then .key = "weightInLbs" else . end))'

To transform the "name" string to a capitalized version starting with the word
"NAME:", do this. (`ascii_upcase` only takes piped output, so we can't do
`ascii_upcase(.)`.)

    cat data.json | jq '[.[].name |= "NAME: " + (.|ascii_upcase)]'
