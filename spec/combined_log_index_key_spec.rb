require 'spec_helper'

module LogWeaver
  class CombinedLogIndexKey
    describe "#<=>" do
      it "should compare timestamp first" do
        ($k_p1_t2 <=> $k_p2_t1).should == ($k_p1_t2.timestamp <=> $k_p2_t1.timestamp)
      end
      it "should compare prefix second" do
        ($k_p1_t1 <=> $k_p2_t1).should == ($k_p1_t1.prefix <=> $k_p2_t1.prefix)
      end
    end
    describe"#to_s" do
      it "prints 'prefix: timestamp'" do
        $k_p1_t1.to_s.should == "#{$p1}#{$t1}"
      end
    end
  end
end
