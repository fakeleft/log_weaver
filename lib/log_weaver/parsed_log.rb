require 'time'

module LogWeaver
  class ParsedLog

    def initialize(log, prefix)
      @prefix = prefix
      @lines = ParsedLog.parse_log log
    end

    def to_s
      lines.map{ |t, ls| "#{prefix}: #{t.strftime("%Y-%m-%d %H:%M:%S.%L")}" << " " << ls.map{ |l| "#{l}"}.join("\n") << "\n" }
    end

    def +

    end
    #private TODO: see http://stackoverflow.com/questions/4952980/creating-private-class-method; test per
    # http://kailuowang.blogspot.ca/2010/08/testing-private-methods-in-rspec.html
    def self.parse_log(log)
      res = {}
      previous_t = nil
      log.string.split("\n").each do |l|
        t = extract_time_stamp(l)
        if t
          res[t] = [l]
          previous_t = t
        else
          raise ArgumentError, "Log does not begin with a timestamp." if previous_t.nil?
          res[previous_t] << l
        end
      end

      res
    end

    def self.extract_time_stamp(line)
      (line =~ /^[0-9]{4}-[01][0-9]-[0-3][0-9] [0-2][0-9](:[0-5][0-9]){2}\.[0-9]{3}/).nil? ? nil : Time.parse(line)
    end

  end
end
