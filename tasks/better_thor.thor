require 'rbconfig'

# Provides convenience methods. Other classes should inherit from this instead
# of Thor.
class BetterThor < Thor
  include Thor::Actions

  no_tasks do
    def info_install(pkg)
      say "++ Installing #{pkg}", :green
    end

    def info_uninstall(pkg)
      say "-- Uninstalling #{pkg}", :red
    end

    # Comma-separated list with "and"
    def pretty_list(array)
      new = array[0...-1]
      new << "and #{array.last}"
      new.join(", ")
    end

    # replace_file and link_file get just "zshenv", not ".zshenv" or
    # "$HOME/.zshenv"
    def replace_file(file)
      full_dotfile_path = File.join(home_directory, dotfile_path(file))
      FileUtils.rm(full_dotfile_path, :force => true)
      link_file(file)
    end

    def link_file(file)
      full_dotfile_path = File.join(home_directory, dotfile_path(file))
      if file =~ /\.erb$/
        file_without_erb = file.sub(/\.erb$/, '')
        say "generating ~/#{dotfile_path(file_without_erb)}"
        File.open(File.join(home_directory, dotfile_path(file_without_erb)), 'w') do |new_file|
          new_file.write ERB.new(File.read(file)).result(binding)
        end
      else
        say "linking ~/#{dotfile_path(file)}"
        FileUtils.ln_s(File.join(Dir.pwd, file), full_dotfile_path)
      end
    end

    def windows?
      Config::CONFIG['host_os'] =~ /mswin|mingw/
    end

    def osx?
      Config::CONFIG['host_os'] =~ /darwin/
    end

    def ruby_19?
      Config::CONFIG['MAJOR'] == '1' and Config::CONFIG['MINOR'] == '9'
    end

    # platform-specific way to represent a dotfile
    # .file for Unix, _file for Windows
    def dotfile_path(fname)
      if windows?
        "_#{fname}"
      else
        ".#{fname}"
      end
    end

    def home_directory
      if ruby_19?
        # Ruby 1.9 handles Windows home dirs just fine
        # http://redmine.ruby-lang.org/issues/show/1147
        File.expand_path("~")
      else
        if windows?
          ENV['USERPROFILE']
        else
          ENV['HOME']
        end
      end
    end

    # No official desc since this really shouldn't be called directly
    def homebrew_installed?
      # Test that `which brew` is executable
      test(?x, `which brew`.chomp)
    end
  end
end
