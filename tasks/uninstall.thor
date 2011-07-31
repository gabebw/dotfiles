class Uninstall < BetterThor
  desc "homebrew", "Uninstall homebrew"
  def homebrew
    uninstalling 'homebrew'

    Dir.chdir(`brew --prefix`.chomp) do
      FileUtils.rm_r("Cellar", :force => true)
      system "brew prune"
      FileUtils.rm_r(%w{Library .git .gitignore bin/brew README.md share/man/man1/brew}, :force => true)
      FileUtils.rm_r(File.expand_path('~/Library/Caches/Homebrew'), :force => true)
    end
  end

  desc "rvm", "Uninstall RVM"
  def rvm
    uninstalling 'RVM'
    warning("!!! This command requires confirmation!")
    system "rvm implode"
  end

  desc "npm", "Uninstall NPM"
  def npm
    system "sudo npm uninstall npm"
  end
end
