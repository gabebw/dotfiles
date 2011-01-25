=begin
The goal is to be able to run `rake` on a brand new OSX system and magically
get my system back, with no need to resort to ln or installation docs and
with a minimum of input from me.

Ideally, it will also work on a Windows box, but that's less important to
me.
=end

require 'rbconfig'
require 'fileutils'

TOPLEVEL = File.dirname(__FILE__)

def info_install(pkg)
  puts "++ Installing #{pkg}"
end

def info_uninstall(pkg)
  puts "-- Uninstalling #{pkg}"
end


# replace_file and link_file get just "zshenv", not ".zshenv" or
# "$HOME/.zshenv"
def replace_file(file)
  full_dotfile_path = File.join(home_directory, dotfile_path(file))
  FileUtils.rm(full_dotfile_path, :force => true)
  link_file(file)
end

def link_file(file)
  full_dotfile_path = File.join(home_directory, dotfile_path(file))
  puts "linking ~/#{dotfile_path(file)}"
  FileUtils.ln_s(File.join(Dir.pwd, file), full_dotfile_path)
end

def is_windows?
  Config::CONFIG['host_os'] =~ /mswin|mingw/
end

def is_ruby_19?
  Config::CONFIG['MAJOR'] == '1' and Config::CONFIG['MINOR'] == '9'
end

# platform-specific way to represent a dotfile
# .file for Unix, _file for Windows
def dotfile_path(fname)
  if is_windows?
    "_#{fname}"
  else
    ".#{fname}"
  end
end

def home_directory
  if is_ruby_19?
    # Ruby 1.9 handles Windows home dirs just fine
    # http://redmine.ruby-lang.org/issues/show/1147
    File.expand_path("~")
  else
    if is_windows?
      ENV['USERPROFILE']
    else
      ENV['HOME']
    end
  end
end

# link dotfiles into ~
namespace :link do
  desc "Link all dotfiles into ~"
  task :all do
    # Via ryan bates, https://github.com/ryanb/dotfiles/blob/master/Rakefile
    replace_all = false
    home_dir = home_directory()
    # Get only top-level, non-ignored files
    files = `git ls-files | grep -v '/'`.split
    files.each do |file|
      next if %w[Rakefile README.textile .gitignore .gitkeep].include?(file)
      dotfile = dotfile_path("#{file}")

      if File.exist?(File.join(home_dir, dotfile))
        if File.identical?(file, File.join(home_dir, dotfile))
          puts "identical ~/#{dotfile}"
        elsif replace_all
          replace_file(file)
        else
          print "overwrite ~/#{dotfile}? [ynaq] "
          case $stdin.gets.chomp
          when 'a'
            replace_all = true
            replace_file(file)
          when 'y'
            replace_file(file)
          when 'q'
            exit
          else
            puts "skipping ~/#{dotfile}"
          end
        end
      else
        link_file(file)
      end
    end
  end
end

namespace :install do
  desc "Install homebrew"
  task :homebrew do
    info_install 'homebrew'
    puts 'You can ignore this message: "/usr/local/.git already exists!"'
    system 'ruby -e "$(curl -fsSL https://gist.github.com/raw/323731/install_homebrew.rb)"'
  end

  # Helpful brews via homebrew
  desc "Install some useful homebrew formulae"
  task :brews => [:homebrew] do
    system <<-EOF
      brew install android-sdk android-ndk \
        colordiff colormake dos2unix \
        fortune git macvim \
        nethack pip python readline \
        watch
    EOF
  end

  desc "Install SLIME, a good Lisp mode for Emacs"
  task :slime do
    Dir.chdir(TOPLEVEL) do
      system "cvs -d :pserver:anonymous:anonymous@common-lisp.net:/project/slime/cvsroot co -d emacs-plugins/slime slime"
    end
  end

  desc "Install (and update) Vim plugins"
  task :vim_plugins => ['update:vim_plugins']

  desc "Install RVM"
  task :rvm do
    info_install 'RVM'
    # Requires "bash -c" because by default, the system command uses
    # /bin/sh, which chokes on the "<"s
    system '/bin/bash -c "bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )"'
  end

  desc "Install Pik (Windows only)"
  task :pik do
    unless is_windows?
      fail "Pik is Windows-only, install:rvm instead"
    end
    `gem install pik`
    puts "Installed Pik gem, now run pik_install"
    puts "Help: https://github.com/vertiginous/pik"
  end

  desc "Install RVM, Homebrew, and useful Homebrew formulae"
  task :all => [:brews, :rvm]
end

desc "Alias for install:all"
task :install => ['install:all']

namespace :uninstall do
  desc "Uninstall homebrew"
  task :homebrew do
    info_uninstall 'homebrew'

    Dir.chdir(`brew --prefix`.chomp) do
      FileUtils.rm_r("Cellar", :force => true)
      system "brew prune"
      FileUtils.rm_r(%w{Library .git .gitignore bin/brew README.md share/man/man1/brew}, :force => true)
      FileUtils.rm_r(File.expand_path('~/Library/Caches/Homebrew'), :force => true)
    end
  end

  desc "Uninstall RVM"
  task :rvm do
    info_uninstall 'RVM'
    puts "!!! This command requires confirmation!"
    system "rvm implode"
  end

  desc "Uninstall everything"
  task :all => [:homebrew, :rvm]
end

desc "Alias for uninstall:all"
task :uninstall => ['uninstall:all']

namespace :update do
  desc "Update everything"
  task :all => [:vim_plugins, :slime]

  desc "Update vim plugins"
  task :vim_plugins do
    $LOAD_PATH << File.join(TOPLEVEL, 'vim')
    require 'update_bundles'
    update_all()
  end

  # cvs checkout will update it too
  desc "Update SLIME"
  task :slime => ['install:slime']
end

desc "Alias for update:all"
task :update => ['update:all']

desc "Install everything and link dotfiles"
task :default => ['install:all', 'link:all']
