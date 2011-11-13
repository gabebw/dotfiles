class Install < BetterThor
  default_task :all

  ALL = [:brews, :rvm, :vim]

  desc "all", "Install a good starting point for your platform"
  def all
    ALL.each{|t| invoke t }
  end

  desc "homebrew", "Install homebrew"
  def homebrew
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

  desc "rvm", "Install RVM"
  def rvm
    installing 'RVM'
    # Requires "bash -c" because by default, the system command uses
    # /bin/sh, which chokes on the "<"s
    system '/bin/bash -c "bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )"'
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
