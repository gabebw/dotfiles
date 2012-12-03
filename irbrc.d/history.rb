IRB.conf[:USE_READLINE] = true

module Readline
  module History
    LOG = "#{ENV["HOME"]}/.irb-save-history"
    def self.write_log(line)
      if line != "exit"
        File.open(LOG, 'ab') {|f| f << "#{line}\n"}
      end
    end
  end

  alias :old_readline :readline
  def readline(*args)
    old_readline(*args).tap do |line|
      History.write_log(line) rescue nil
    end
  end
end

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV["HOME"]}/.irb-save-history"
