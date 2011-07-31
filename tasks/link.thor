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
          warning("identical ~/#{dotfile_without_erb}")
        elsif replace_all
          force_link_file(file)
        else
          warning("overwrite ~/#{dotfile_without_erb}? [ynaq] ")
          case $stdin.gets.chomp
          when 'a'
            replace_all = true
            force_link_file(file)
          when 'y'
            force_link_file(file)
          when 'q'
            exit
          else
            info("skipping ~/#{dotfile_without_erb}")
          end
        end
      else
        link_file(file)
      end
    end
  end

  no_tasks do
    # replace_file and link_file get just "zshenv", not ".zshenv" or
    # "$HOME/.zshenv"
    def force_link_file(file)
      full_dotfile_path = File.join(home_directory, dotfile_path(file))
      FileUtils.rm(full_dotfile_path, :force => true)
      link_file(file)
    end

    def link_file(file)
      full_dotfile_path = File.join(home_directory, dotfile_path(file))
      if file =~ /\.erb$/
        file_without_erb = file.sub(/\.erb$/, '')
        info("generating ~/#{dotfile_path(file_without_erb)}")
        File.open(File.join(home_directory, dotfile_path(file_without_erb)), 'w') do |new_file|
          new_file.write ERB.new(File.read(file)).result(binding)
        end
      else
        info("linking ~/#{dotfile_path(file)}")
        FileUtils.ln_s(File.join(Dir.pwd, file), full_dotfile_path)
      end
    end
  end
end
