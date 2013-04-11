require 'spec_helper'

module LogWeaver
  class CombinedLogIndexKey
    describe "#<=>" do
      it "should compare prefix first" do
        ($k_p1_t2 <=> $k_p2_t1).should == ($k_p1_t2.prefix <=> $k_p2_t1.prefix)
      end
      it "should compare timestamp second" do
        ($k_p1_t1 <=> $k_p1_t2).should == ($k_p1_t1.timestamp <=> $k_p1_t2.timestamp)
      end
    end
  end
end
