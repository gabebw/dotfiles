require 'rubygems'
require 'pp'

=begin
Tips
_ (an underscore) is always set to the result of the last successful expression
  (so you can't capture errors)
  But this won't work:
  %w{a b c}; _.map{|x| 'x'}. You have to do it in 2 lines.
=end

# ripl sources this file too, so check which one we're using.
# ripl-irb defines IRB constant, so we check for nonexistence of Ripl
using_irb = (not defined?(Ripl))

def is_rails_3?
  Object.const_defined?(:Rails) && Rails::VERSION::STRING.to_i == 3
end

def is_rails_2?
  Object.const_defined?(:Rails) && Rails::VERSION::STRING.to_i == 2
end

# To install all of these gems:
# gem install awesome_print map_by_method what_methods wirble hirb
%w{ap map_by_method what_methods wirble hirb}.each do |pkg|
  begin
    require pkg
  rescue LoadError => err
    $stderr.puts "Couldn't load something for irb: #{err}"
  end
end

if using_irb
  IRB.conf[:AUTO_INDENT] = true

  # Set up Wirble, if it was loaded successfully
  if defined?(Wirble)
    Wirble.init
    Wirble.colorize
  end
end

# Set up Hirb, if it was loaded successfully
Hirb::View.enable if defined?(Hirb)

if is_rails_3?
  unless Rails.logger
    Rails.logger = ActiveSupport::BufferedLogger.new(STDOUT)
  end
  # Now you can do new_user_path inside `rails console`
  include Rails.application.routes.url_helpers
elsif is_rails_2? and ! Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
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
