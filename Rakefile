=begin
The goal is to be able to run `rake` on a brand new OSX system and magically
get my system back, with no need to resort to ln or installation docs and
with a minimum of input from me.

Ideally, it will also work on a Windows box, but that's less important to
me.
=end

require 'fileutils'
require 'erb'

require './tasks/util'

Dir['tasks/*.rake'].each{|f| load f }

TOPLEVEL = File.dirname(__FILE__)

namespace :new do
  desc "Change your shell to ZSH"
  task :zsh do
    system "chsh -s `which zsh` #{ENV['USER']}"
  end
end

if osx?
  desc "Everything a new OS X laptop needs"
  task :new => ['new:zsh', 'install:vim', 'install:rvm', 'install:brews']

  desc "Run the :new task and link dotfiles"
  task :default => [:new, 'link:all']
elsif windows?
  desc "Install Pik and link dotfiles"
  task :default => ['install:pik', 'link:all']
end
