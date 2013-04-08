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
    def self.parse_log(log)
      res = {}
      previous_key = nil
      log.string.split("\n").each do |line|
        (timestamp, message) = extract_time_stamp(line)
        if timestamp
          key = timestamp
          res[key] = []
          previous_key = key
        else
          raise ArgumentError, "Log does not begin with a timestamp." if previous_key.nil?
        end

        res[previous_key] << message
      end
      res
    end

    def self.extract_time_stamp(line)
      timestamp = line[/^[0-9]{4}-[01][0-9]-[0-3][0-9] [0-2][0-9](:[0-5][0-9]){2}\.[0-9]{3}/,0]
      message = line.sub(/^#{timestamp}/,'')
      timestamp = Time.parse(timestamp) unless timestamp.nil?
      [timestamp,message]
    end

  end
end
