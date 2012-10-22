require "rspec"
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module LogWeaver
  class ParsedLogKey
    describe "#<=>" do
      let(:t) { Time.now }
      it "should compare prefix as the most significant item" do
        k1 = ParsedLogKey.new( "a", t + 1, 2 )
        k2 = ParsedLogKey.new( "b", t, 1 )
        (k1 <=> k2).should == (k1.prefix <=> k2.prefix)
      end
      it "should compare timestamp as the second least significant item" do
        k1 = ParsedLogKey.new( "a", t, 2 )
        k2 = ParsedLogKey.new( "a", t + 1, 1 )
        (k1 <=> k2).should == (k1.timestamp <=> k2.timestamp)
      end
      it "should compare count as the least significant item" do
        k1 = ParsedLogKey.new( "a", t, 1 )
        k2 = ParsedLogKey.new( "a", t, 2 )
        (k1 <=> k2).should == (k1.count <=> k2.count)
      end
    end
  end
end
