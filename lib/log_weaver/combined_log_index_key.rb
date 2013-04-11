module LogWeaver
  CombinedLogIndexKey = Struct.new(:prefix, :timestamp) do
    include Comparable

    def <=>(other)
      return prefix <=> other.prefix unless prefix == other.prefix
      return timestamp <=> other.timestamp
    end
  end
end
