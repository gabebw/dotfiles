# To install all of these gems:
# gem install awesome_print map_by_method what_methods wirble hirb
begin
    require 'rubygems'
    require 'pp'
    # awesome_print
    require 'ap'
    require 'map_by_method'
    require 'what_methods'
    IRB.conf[:AUTO_INDENT]=true
    require 'wirble'
    Wirble.init
    Wirble.colorize

    require 'logger'
    if ENV.include?('RAILS_ENV')&& !Object.const_defined?('RAILS_DEFAULT_LOGGER')
     Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
    end

    require 'hirb'
    Hirb::View.enable

rescue LoadError => err
    $stderr.puts "Couldn't load something for irb: #{err}"
end

class Object
  # Get an object's "own methods" - methods that only it (not Object) has
  def ownm
    return self.methods - Object.methods
  end
end
