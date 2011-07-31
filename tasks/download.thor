class Download < Thor
  default_task :download

  no_tasks do
    def system_open(url)
      system "open -g #{url}"
    end
  end

  desc "all", "Open all download pages (default)"
  def all
    [:iterm2, :dropbox, :growl].each do |task|
      invoke task
    end
  end

  desc "iterm2", "Open the iTerm2 download page"
  def iterm2
    system_open('http://code.google.com/p/iterm2/downloads/list')
  end

  desc "dropbox", "Open the Dropbox download page"
  def dropbox
    system_open('https://www.dropbox.com/install')
  end

  desc "growl", "Open the Growl download page"
  def growl
    system_open('http://growl.info/')
  end
end
