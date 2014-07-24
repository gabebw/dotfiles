require 'rubygems'
require 'pp'

# IRB by default somehow requires like 75% of the date and time libraries, which
# leads to some methods not being defined, even though Time and Date and
# DateTime constants are there. I have no idea how IRB manages this.
require 'time'
require 'date'

IRB.conf[:AUTO_INDENT] = true

def require_rb_files_from(dir)
  Dir.glob(File.join(dir, '*.rb')) do |file|
    require file
  end
end

require_rb_files_from(File.join(ENV['HOME'], '.irbrc.d'))
