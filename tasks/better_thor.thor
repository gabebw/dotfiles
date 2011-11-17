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

    def warning(message)
      say "==> #{message}", :yellow
    end

    def info(message)
      say "==> #{message}"
    end

    def success(message)
      say "==> #{message}", :green
    end

    def ruby_19?
      Config::CONFIG['MAJOR'] == '1' && Config::CONFIG['MINOR'] == '9'
    end

    # platform-specific way to represent a dotfile
    # .file for Unix, _file for Windows
    def dotfile_path(fname)
      ".#{fname}"
    end

    def home_directory
      # Ruby 1.9 handles Windows home dirs just fine
      ruby_19? ? File.expand_path("~") : ENV['HOME']
    end

    def homebrew_installed?
      # Test that `which brew` is executable
      test(?x, `which brew`.chomp)
    end
  end
end
