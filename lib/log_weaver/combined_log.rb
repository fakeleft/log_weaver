module LogWeaver

  class CombinedLog
    attr_accessor :logs

    def initialize(logs)
      @logs = logs
      @index = CombinedLog::build_index(@logs)
    end

    def self.build_index(logs)
      # need to sort by timestamp, then prefix
      index = {}
      logs.each do |log|
        log.lines.each do |t,l|
          key = CombinedLogIndexKey.new(log.prefix, t)
          index[key] = l
        end
      end
      #TODO: sorting at this point may have seriously bad performance for large logs; consider a
      # data structure that stays sorted as you insert
      Hash[index.sort]
    end

    def to_s
      res = ""
      @index.each do |key, lines|
        res << "#{key}#{lines.join("\n")}\n"
      end
      res
    end
  end
end


