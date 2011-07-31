class Install < BetterThor
  default_task :all

  # install:all is platform-dependent
  CROSS_PLATFORM = [:vim]
  UNIX           = [:rvm] + CROSS_PLATFORM
  WINDOWS        = [:pik] + CROSS_PLATFORM
  OSX            = [:brews] + UNIX

  desc "all", "Install a good starting point for your platform"
  def all
    if windows?
      WINDOWS.each{|t| invoke t }
    elsif osx?
      OSX.each{|t| invoke t }
    else
      UNIX.each{|t| invoke t }
    end
  end

  desc "homebrew", "Install homebrew (OSX only)"
  def homebrew
    fail "Not OSX, can't install Homebrew" unless osx?

    installing 'homebrew'
    # Don't fail, since they may have a broken install
    warn "Homebrew already installed!" if homebrew_installed?
    info('You can ignore this message: "/usr/local/.git already exists!"')
    system 'ruby -e "$(curl -fsSL https://gist.github.com/raw/323731/install_homebrew.rb)"'
  end

  desc "vim", "Install Pathogen and Vundle"
  def vim
    invoke "install:vim:pathogen"
    invoke "install:vim:vundle"
  end

  class Vim < BetterThor
    desc "pathogen", "Install Pathogen"
    def pathogen
      require 'open-uri'
      create_file("vim/autoload/pathogen.vim") do
        open('https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim').read
      end
    end

    desc "vundle", "Install Vundle"
    def vundle
      invoke :pathogen
      `git clone http://github.com/gmarik/vundle.git vim/bundle/vundle`
    end

    desc "plugins", "Install Vim plugins"
    def plugins
      invoke :vundle
      warning("To install/update Vim plugins, start Vim and run :BundleInstall/:BundleInstall!")
    end
  end

  # Helpful brews via homebrew
  desc "brews", "Install some useful homebrew formulae"
  def brews
    invoke :homebrew
    system "brew install colordiff colormake ack fortune git macvim watch memcached"
  end

  desc "rvm", "Install RVM (Unixy OSes only)"
  def rvm
    fail "RVM doesn't work on Windows, install:pik instead" if windows?

    installing 'RVM'
    # Requires "bash -c" because by default, the system command uses
    # /bin/sh, which chokes on the "<"s
    system '/bin/bash -c "bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )"'
  end

  desc "pik", "Install Pik (Windows only)"
  def pik
    fail "Pik is Windows-only, install:rvm instead" unless windows?

    `gem install pik`
    announce("Installed Pik gem, now run pik_install")
    announce("Help: https://github.com/vertiginous/pik")
  end

  desc "npm", "Install NPM, the node package manager"
  def npm
    system "curl http://npmjs.org/install.sh | sh"
  end

  desc "pow", "Install Pow"
  def pow
    system "curl get.pow.cx | sh"
  end
end
