class Download < BetterThor
  default_task :download

  no_tasks do
    def open_url(url)
      run "open -g #{url}"
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
    open_url('http://code.google.com/p/iterm2/downloads/list')
  end

  desc "dropbox", "Open the Dropbox download page"
  def dropbox
    open_url('https://www.dropbox.com/install')
  end

  desc "growl", "Open the Growl download page"
  def growl
    open_url('http://growl.info/')
  end
end
