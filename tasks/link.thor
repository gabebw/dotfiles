# link dotfiles into ~
class Link < BetterThor
  default_task :all

  desc "all", "Link all dotfiles into ~"
  def all
    # Via ryan bates, https://github.com/ryanb/dotfiles/blob/master/Rakefile
    replace_all = false
    home_dir = home_directory()
    # Get only top-level, non-ignored files
    files = `git ls-files | grep -v '/'`.split
    files.each do |file|
      next if %w[Rakefile README.textile .gitignore .gitkeep].include?(file)
      dotfile_with_erb = dotfile_path(file)
      dotfile_without_erb = dotfile_path("#{file.sub(/\.erb$/, '')}")

      if File.exist?(File.join(home_dir, dotfile_without_erb))
        if File.identical?(file, File.join(home_dir, dotfile_without_erb))
          puts "identical ~/#{dotfile_without_erb}"
        elsif replace_all
          replace_file(file)
        else
          print "overwrite ~/#{dotfile_without_erb}? [ynaq] "
          case $stdin.gets.chomp
          when 'a'
            replace_all = true
            replace_file(file)
          when 'y'
            replace_file(file)
          when 'q'
            exit
          else
            puts "skipping ~/#{dotfile_without_erb}"
          end
        end
      else
        link_file(file)
      end
    end
  end
end
