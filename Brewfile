# vim: syntax=ruby filetype=ruby

# Lets us do `brew services restart postgres`, etc
tap 'homebrew/services'

# Old versions of some packages
tap 'homebrew/versions'

# It me
tap 'gabebw/formulae'

# Find my most-used CLI commands
brew 'most-used'

brew 'coreutils'

# Command-line Spotify interface
# https://github.com/hnarayanan/shpotify
brew 'shpotify'

# sed for json: https://robots.thoughtbot.com/jq-is-sed-for-json
brew 'jq'

# Qt5.5 for capybara-webkit, because Qt 5.6 doesn't work except with the most
# recent version
brew 'qt@5.5'
# --overwrite: overwrite any Qt4 files that might be there
# --force: required because Qt is keg-only
`brew link --overwrite --force qt@5.5`

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

# The latest version of Docker is too new to work with Heroku's Docker registry.
# Install Docker 1.11 instead, which is old enough to work with Heroku.
brew 'docker@1.11'

# Fast, hip replacement for grep
brew 'ripgrep'

# Official AWS CLI
brew 'awscli'

# Like search, but more elastic
brew 'elasticsearch'

brew 'youtube-dl'
# youtube-dl uses ffmpeg to automatically fix some issues in downloaded files
brew 'ffmpeg'
