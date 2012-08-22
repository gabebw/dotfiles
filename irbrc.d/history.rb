IRB.conf[:USE_READLINE] = true

module Readline
  module History
    LOG = "#{ENV["HOME"]}/.irb-save-history"
    def self.write_log(line)
      File.open(LOG, 'ab') {|f| f << "#{line}\n"} unless line == "exit"
    end
  end

  alias :old_readline :readline
  def readline(*args)
    ln = old_readline(*args)
    begin
      History.write_log(ln)
    rescue
    end
    ln
  end
end

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV["HOME"]}/.irb-save-history"
