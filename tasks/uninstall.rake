desc "Alias for uninstall:all"
task :uninstall => ['uninstall:all']

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

  desc "Uninstall NPM"
  task :npm do
    system "sudo npm uninstall npm"
  end
end
