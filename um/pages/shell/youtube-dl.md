# youtube-dl
{:data-section="shell"}
{:data-date="August 30, 2018"}
{:data-extra="Um Pages"}

## DESCRIPTION

Don't use `xargs youtube-dl`, use `youtube-dl -a -`.

Plus, you can pass it an MP4 directly and get the benefit of its excellent
downloading capability. To use the basename of the URL that you pass:

    youtube-dl -o '%(title)s.%(ext)s'

## OPTIONS

-a, --batch-file FILE
: File containing URLs to download ('-' for stdin), one URL per line.  Lines starting with '#', ';' or ']' are considered as comments and ignored.

--match-title REGEX
: Only download items that match a title (case-insensitive)

--min-views NUMBER
: Only download items with this many views or more

-w, --no-overwrites
: Do not overwrite files
