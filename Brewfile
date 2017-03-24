# vim: syntax=ruby filetype=ruby

# Lets us do `brew services restart postgres`, etc
tap 'homebrew/services'

# Old versions of some packages
tap 'homebrew/versions'

brew 'coreutils'

# sed for json: https://robots.thoughtbot.com/jq-is-sed-for-json
brew 'jq'

# Qt5.5 for capybara-webkit, because Qt 5.6 doesn't work except with the most
# recent version
tap 'homebrew/versions'
brew 'qt55'
# --overwrite: overwrite any Qt4 files that might be there
# --force: required because qt55 is keg-only
`brew link --overwrite --force qt55`

# grep for ps
brew 'pgrep'

# The recommended way to use Heroku
brew 'heroku'

# colorful diffs (alias diff='colordiff -u')
brew 'colordiff'

# a better ack/grep
brew 'the_silver_searcher'

# so :Rtags works
brew 'ctags'

# It's vim
brew 'mercurial'
brew 'vim'

# Used in Rails projects
brew 'phantomjs'

# Fast GitHub client
brew 'hub'

# Fuzzy finder
brew 'fzf'

# thoughtbot stuff like rcm
tap 'thoughtbot/formulae'
brew 'rcm'

# Install zsh 5.2+ (OS X ships with 5.0) to fix this issue:
# https://github.com/robbyrussell/oh-my-zsh/issues/4932
brew 'zsh'

# The latest version of Docker is too new to work with Heroku's Docker registry.
# Install Docker 1.11 instead, which is old enough to work with Heroku.
brew 'homebrew/versions/docker111'

if ENV.fetch("SHELL", "") != "/usr/local/bin/zsh"
  puts "To use the Homebrew-installed ZSH:"
  puts "  sudo echo /usr/local/bin/zsh >> /etc/shells"
  puts "  chsh -s /usr/local/bin/zsh"
end

# Cask: install binaries
cask 'alfred'
cask 'dropbox'
cask 'google-chrome'
cask 'netnewswire'
cask 'vlc'
# HOMM3
cask 'wineskin-winery'
# Use Cask so we get Cargo, too
cask 'rust'
# Keyboard remapping on macOS
cask 'karabiner-elements'
