desc "Alias for install:all"
task :install => ['install:all']

namespace :install do
  # install:all is platform-dependent

  # Cross-platform
  xplatform = [:vim_plugins]
  unix = [:rvm] + xplatform
  windows = [:pik] + xplatform
  osx = [:brews] + unix

  if is_windows?
    desc "Install #{pretty_list(windows)}"
    task :all => windows
  elsif is_osx?
    desc "Install #{pretty_list(osx)}"
    task :all => osx
  else
    desc "Install #{pretty_list(unix)}"
    task :all => unix
  end

  desc "Install homebrew (OSX only)"
  task :homebrew do
    fail "Not OSX, can't install Homebrew" unless is_osx?

    info_install 'homebrew'
    # Don't fail, since they may have a broken install
    warn "Homebrew already installed!" if homebrew_is_installed?
    puts 'You can ignore this message: "/usr/local/.git already exists!"'
    system 'ruby -e "$(curl -fsSL https://gist.github.com/raw/323731/install_homebrew.rb)"'
  end

  desc "Install Pathogen and Vundle"
  task :vim => ["vim:pathogen", "vim:vundle"]

  namespace :vim do
    desc "Install Pathogen"
    task :pathogen => "pathogen.vim"

    desc "Install Vundle"
    task :vundle => ["autoload/vundle.vim", :pathogen]

    directory "vim/bundle/vundle"
    file "autoload/vundle.vim" => "vim/bundle/vundle" do |t|
      `git clone http://github.com/gmarik/vundle.git vim/bundle/vundle`
    end

    directory "vim/autoload"
    file "pathogen.vim" => "vim/autoload" do |t|
      require 'open-uri'
      path = "vim/autoload/pathogen.vim"
      File.open(path, 'w') do |f|
        f << open('https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim').read
      end
    end
  end

  desc "Install Vim plugins"
  task :vim_plugins => "vim:vundle" do
    puts "To install/update Vim plugins, start Vim and run :BundleInstall"
  end

  # Helpful brews via homebrew
  desc "Install some useful homebrew formulae"
  task :brews => [:homebrew] do
    system "brew install colordiff colormake ack fortune git macvim watch memcached"
  end

  desc "Install RVM (Unixy OSes only)"
  task :rvm do
    fail "RVM doesn't work on Windows, install:pik instead" if is_windows?

    info_install 'RVM'
    # Requires "bash -c" because by default, the system command uses
    # /bin/sh, which chokes on the "<"s
    system '/bin/bash -c "bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )"'
  end

  desc "Install Pik (Windows only)"
  task :pik do
    fail "Pik is Windows-only, install:rvm instead" unless is_windows?

    `gem install pik`
    puts "Installed Pik gem, now run pik_install"
    puts "Help: https://github.com/vertiginous/pik"
  end

  desc "Install NPM, the node package manager"
  task :npm do
    system "curl http://npmjs.org/install.sh | sh"
  end
end
