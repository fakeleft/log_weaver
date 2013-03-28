module LogWeaver

  class CombinedLog
    attr_accessor :logs

    def initialize(logs)
      @logs = logs
    end
  end
end


