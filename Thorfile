=begin
The goal is to be able to run `thor new` on a brand new OSX system and magically
get my system back, with no need to resort to ln or installation docs and
with a minimum of input from me.

Ideally, it will also work on a Windows box, but that's less important to
me.
=end

require 'fileutils'
require 'erb'
load './tasks/better_thor.thor'

class New < BetterThor
  default_task :all

  desc "all", "Everything your new laptop needs"
  def all
    invoke "new:zsh" unless (windows? || using_zsh?)
    invoke "install:all"
    invoke "link:all"
  end

  no_tasks do
    def using_zsh?
      ENV['SHELL'] =~ /zsh$/
    end
  end

  desc "zsh", "Change your shell to ZSH"
  def zsh
    system "chsh -s `which zsh` #{ENV['USER']}"
  end
end
