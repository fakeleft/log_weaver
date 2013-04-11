module LogWeaver

  class CombinedLog
    attr_accessor :logs

    def initialize(logs)
      @logs = logs
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

      index
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


