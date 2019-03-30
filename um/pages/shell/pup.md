# pup -- parse and prettify HTML
{:data-section="shell"}
{:data-date="August 30, 2018"}
{:data-extra="Um Pages"}

# Examples

Print pretty HTML:

    curl example.com | pup --color

Print HTML for matching selectors and everything inside them:

    pup 'td.title a'

Get an attribute, like `href`:

    pup 'td.title a attr{href}'

Get inner text:

    pup 'td.title a text{}'

# OPTIONS
