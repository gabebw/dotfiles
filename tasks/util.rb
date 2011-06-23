require 'rbconfig'

def info_install(pkg)
  puts "++ Installing #{pkg}"
end

def info_uninstall(pkg)
  puts "-- Uninstalling #{pkg}"
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
    puts "generating ~/#{dotfile_path(file_without_erb)}"
    File.open(File.join(home_directory, dotfile_path(file_without_erb)), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/#{dotfile_path(file)}"
    FileUtils.ln_s(File.join(Dir.pwd, file), full_dotfile_path)
  end
end

def is_windows?
  Config::CONFIG['host_os'] =~ /mswin|mingw/
end

def is_osx?
  Config::CONFIG['host_os'] =~ /darwin/
end

def is_ruby_19?
  Config::CONFIG['MAJOR'] == '1' and Config::CONFIG['MINOR'] == '9'
end

# platform-specific way to represent a dotfile
# .file for Unix, _file for Windows
def dotfile_path(fname)
  if is_windows?
    "_#{fname}"
  else
    ".#{fname}"
  end
end

def home_directory
  if is_ruby_19?
    # Ruby 1.9 handles Windows home dirs just fine
    # http://redmine.ruby-lang.org/issues/show/1147
    File.expand_path("~")
  else
    if is_windows?
      ENV['USERPROFILE']
    else
      ENV['HOME']
    end
  end
end

# No official desc since this really shouldn't be called directly
def homebrew_is_installed?
  # Test that `which brew` is executable
  test(?x, `which brew`.chomp)
end
