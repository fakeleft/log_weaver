require 'time'

module LogWeaver
  class ParsedLog
    attr_accessor :lines
    attr_reader :prefix

    def initialize(log, prefix)
      @prefix = prefix
      @lines = ParsedLog.parse_log log, prefix
    end

    def to_s
      lines.map { |t, ls| ls.map { |l| "#{l}" }.join("\n") }.join("\n")
    end

    def +(other)
      res = self.dup
      res.lines = Hash[self.lines.merge(other.lines).sort]
      res
    end

    #private TODO: see http://stackoverflow.com/questions/4952980/creating-private-class-method; test per
    # http://kailuowang.blogspot.ca/2010/08/testing-private-methods-in-rspec.html
    def self.parse_log(log, prefix = "")
      res = {}
      previous_key = nil
      log.string.split("\n").each do |l|
        t = extract_time_stamp(l)

        if t
          key = ParsedLogKey.new(prefix, t, 1)
          unless previous_key.nil?
            key = ParsedLogKey.new(prefix, t, previous_key.count + 1) if t == previous_key.timestamp
          end
          res[key] = []
          previous_key = key
        else
          raise ArgumentError, "Log does not begin with a timestamp." if previous_key.nil?
        end

        res[previous_key] << l
      end

      # prepend the prefix to every line with a time stamp
      res.each_key{ |k| res[k][0] = prefix + res[k][0] }

    end

    def self.extract_time_stamp(line)
      (line =~ /^[0-9]{4}-[01][0-9]-[0-3][0-9] [0-2][0-9](:[0-5][0-9]){2}\.[0-9]{3}/).nil? ? nil : Time.parse(line)
    end

  end
end
