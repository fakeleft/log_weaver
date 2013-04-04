module LogWeaver

  class CombinedLog
    attr_accessor :logs

    def initialize(logs)
      @logs = logs
    end

    def to_s
      res = ""
      #TODO: sorting at this point may have seriously bad performance for large logs; consider a
      # data structure that stays sorted as you insert
      @index.sort.each do |entry|
        res << "#{entry.prefix}:#{entry.lines.join("\n")}"
      end
      res
    end
  end
end


