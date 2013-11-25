require 'rubygems'
require 'pp'

# Save IRB History
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
IRB.conf[:AUTO_INDENT] = true

def is_rails_4?
  Object.const_defined?(:Rails) && Rails::VERSION::STRING.to_i == 4
end

def is_rails_3?
  Object.const_defined?(:Rails) && Rails::VERSION::STRING.to_i == 3
end

# To install all of these gems:
# gem install wirble hirb
%w{wirble hirb}.each do |pkg|
  begin
    require pkg
  rescue LoadError => err
    $stderr.puts "Couldn't load something for irb: #{err}"
  end
end

# Set up Wirble, if it was loaded successfully
if defined?(Wirble)
  Wirble.init
  Wirble.colorize
end

# Set up Hirb, if it was loaded successfully
Hirb::View.enable if defined?(Hirb)

if is_rails_3?
  unless Rails.logger
    Rails.logger = ActiveSupport::BufferedLogger.new(STDOUT)
  end
  # Now you can do new_user_path inside `rails console`
  include Rails.application.routes.url_helpers
end

# Monkeypatching ahoy!
class Class
  # Get an object's "own methods" - methods that only it (not Object) has
  def ownm
    methods - Object.methods
  end
end

class Array
  def self.toy
    [1, 2, 3] + %w{a b c}
  end
end

class Hash
  def self.toy
    {'a' => 'b',
     'foo' => 'bar',
     1 => 2}
  end
end
