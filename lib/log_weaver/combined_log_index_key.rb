module LogWeaver
  CombinedLogIndexKey = Struct.new(:prefix, :timestamp) do
    include Comparable

    def <=>(other)
      return timestamp <=> other.timestamp unless timestamp == other.timestamp
      return prefix <=> other.prefix
    end

    def to_s
      "#{prefix}#{timestamp}"
    end
  end
end
