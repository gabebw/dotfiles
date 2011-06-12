namespace :download do
  desc "Open the iTerm2 download page"
  task :iterm2 do
    system %{open "http://code.google.com/p/iterm2/downloads/list"}
  end

  desc "Open the Dropbox download page"
  task :dropbox do
    system %{open "https://www.dropbox.com/install"}
  end
end
