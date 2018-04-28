# vim: syntax=ruby filetype=ruby

# Lets us do `brew services restart postgres`, etc
tap 'homebrew/services'

# Old versions of some packages
tap 'homebrew/versions'

# It me
tap 'gabebw/formulae'

# https://unused.codes/
tap 'joshuaclayton/formulae'
# Don't use ag, I use rg
brew 'unused', args: ['--without-ag']

# Find my most-used CLI commands
brew 'most-used'

brew 'coreutils'

# Command-line Spotify interface
# https://github.com/hnarayanan/shpotify
brew 'shpotify'

# sed for json: https://robots.thoughtbot.com/jq-is-sed-for-json
brew 'jq'

# sed for xml: http://xmlstar.sourceforge.net/doc/UG/ch04.html#idm47989546279904
brew 'xmlstarlet'

# sed for html: https://github.com/ericchiang/pup
brew 'https://raw.githubusercontent.com/EricChiang/pup/master/pup.rb'

# sed (and more) for CSV
# More: https://robots.thoughtbot.com/csvkit-brings-the-unix-philosophy-to-csv
brew 'csvkit'

# Qt5.5 for capybara-webkit, because Qt 5.6 doesn't work except with the most
# recent version
brew 'qt@5.5'

# grep for ps
brew 'pgrep'

# The recommended way to use Heroku
brew 'heroku'

# Use version 3.4+ for colorful diffs with --color
brew 'diffutils'

# so :Rtags works
brew 'ctags'

# My favorite editor
brew 'vim'

# Used in Rails projects
brew 'phantomjs'

# Fast GitHub client, used in git-create-pull-request
brew 'hub'

# Don't install completions, in favor of using Zsh's (better) git completions
brew 'git', args: ['--without-completions']

# Fuzzy finder
brew 'fzf'

# thoughtbot stuff like rcm
tap 'thoughtbot/formulae'
brew 'rcm'
brew 'parity'

# Fast, hip replacement for grep
brew 'ripgrep'

# Official AWS CLI
brew 'awscli'

# Like search, but more elastic
brew 'elasticsearch@5.6'

brew 'youtube-dl'
# youtube-dl uses ffmpeg to automatically fix some issues in downloaded files
brew 'ffmpeg'

# I love `sponge` so much.
brew 'moreutils'

# gsed lets you use newlines
brew 'gnu-sed'

# Provides `numsum`, among others.
brew 'num-utils'

# https://tldr.sh/
# Man pages, but with practical examples.
brew 'tldr'

brew 'node'
brew 'yarn'
brew 'nvm'

# a Postgres pager
brew 'pspg'
