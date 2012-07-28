require 'rubygems'
require 'pp'

# To install all of these gems:
# gem install awesome_print map_by_method what_methods wirble hirb
%w{ap map_by_method what_methods wirble hirb}.each do |pkg|
  begin
    require pkg
  rescue LoadError => err
    STDERR.puts "Couldn't load #{pkg}"
    STDERR.puts "gem install awesome_print map_by_method what_methods wirble hirb"
    break
  end
end

IRB.conf[:AUTO_INDENT] = true

# Set up Wirble, if it was loaded successfully
if defined?(Wirble)
  Wirble.init
  Wirble.colorize
end

# Set up Hirb, if it was loaded successfully
Hirb::View.enable if defined?(Hirb)

class Array
  def self.toy
    [1, 2, 3] + %w(a b c)
  end
end

class Hash
  def self.toy
    {'a' => 'b',
     'foo' => 'bar',
     1 => 2}
  end
end
