module LogWeaver
  class ParsedLog

    def initialize(file, prefix)
      @prefix = prefix
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
      log.split("\n").each do |l|
        (t, rest) = get_time_stamp(l)
        if t

        end
      end

    end

  end
end
