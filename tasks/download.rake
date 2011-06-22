def system_open(url)
  system "open #{url}"
end

desc "Alias for download:all"
task :download => ['download:all']

namespace :download do
  desc "Open all download pages"
  task :all => [:iterm2, :dropbox, :growl]

  desc "Open the iTerm2 download page"
  task :iterm2 do
    system_open('http://code.google.com/p/iterm2/downloads/list')
  end

  desc "Open the Dropbox download page"
  task :dropbox do
    system_open('https://www.dropbox.com/install')
  end

  desc "Open the Growl download page"
  task :growl do
    system_open('http://growl.info/')
  end
end
