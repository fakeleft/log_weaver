
class Array
  def uniq?
    self.length == self.uniq.length
  end
end

class Time
  def to_s
    self.strftime("%Y-%m-%d %H:%M:%S.%L")
  end
end


