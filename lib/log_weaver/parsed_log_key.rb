module LogWeaver
  ParsedLogKey = Struct.new( :prefix, :timestamp, :count ) do
    include Comparable

    def <=>(other)
      return prefix <=> other.prefix unless prefix == other.prefix
      return timestamp <=> other.timestamp unless timestamp == other.timestamp
      count <=> other.count
    end
  end
end
