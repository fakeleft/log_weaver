module LogWeaver
  class ParsedLog
    def initialize file, prefix

    end
    def to_s
      lines.map{ |t, ls| "#{prefix}: #{t.strftime("%Y-%m-%d %H:%M:%S.%L")}" << " " << ls.map{ |l| "#{l}"}.join("\n") << "\n" }
    end
    def +

    end
  end
end
