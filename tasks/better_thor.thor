require 'rbconfig'

# Provides convenience methods. Other classes should inherit from this instead
# of Thor.
class BetterThor < Thor
  include Thor::Actions

  no_tasks do
    def installing(pkg)
      say "++ Installing #{pkg}", :green
    end

    def uninstalling(pkg)
      say "-- Uninstalling #{pkg}", :red
    end

    def windows?
      Config::CONFIG['host_os'] =~ /mswin|mingw/
    end

    def osx?
      Config::CONFIG['host_os'] =~ /darwin/
    end

    def ruby_19?
      Config::CONFIG['MAJOR'] == '1' && Config::CONFIG['MINOR'] == '9'
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

    def homebrew_installed?
      # Test that `which brew` is executable
      test(?x, `which brew`.chomp)
    end
  end
end
