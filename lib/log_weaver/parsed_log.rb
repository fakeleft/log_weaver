require 'time'

module LogWeaver
  class ParsedLog
    attr_accessor :lines #TODO: rename; attr_reader should suffice
    attr_reader :prefix

    def initialize(prefix, log)
      @prefix = prefix
      @lines = ParsedLog.parse_log log
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
          res[key] = [] unless key == previous_key
          previous_key = key
        else
          raise ArgumentError, "Log does not begin with a timestamp." if previous_key.nil?
        end

        res[previous_key] << line #message
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
