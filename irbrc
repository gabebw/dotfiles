require 'rubygems'
require 'pp'

IRB.conf[:AUTO_INDENT] = true

class Array
  def self.toy
    [1, 2, 3] + %w(a b c)
  end
end

class Hash
  def self.toy
    {
      1 => 2
      'a' => 'b',
      'foo' => 'bar',
      :hello => 'there'
    }
  end
end
