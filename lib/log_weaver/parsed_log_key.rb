module LogWeaver
  ParsedLogKey = Struct.new( :prefix, :timestamp, :count ) do
    include Comparable

    def <=>(other)
      return timestamp <=> other.timestamp unless timestamp == other.timestamp
      return count <=> other.count unless count == other.count
      prefix <=> other.prefix
    end
  end
end
