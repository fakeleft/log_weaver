require 'spec_helper'
require 'unindent'

module LogWeaver
  describe CombinedLog do
    before(:all) do
    end


    describe ".initialize" do
      it "stores the logs" do
        @cl.logs.should == @logs
      end
    end
    describe ".build_index" do
      # note: it's much briefer/easier/more readable to give symbolic descriptions
      # for the examples; pn is the prefix, tn is the timestamp, ln are the line contents
      it "handles [p1_t1_l1, p2_t2_l1] (2 logs, ordered timestamps, 1 line each)" do
        CombinedLog.build_index([$pl_p1_t1_l1, $pl_p2_t2_l1]).to_a.should == $hash_p1_t1_l1_and_p2_t2_l1.to_a
      end
      it "handles [p1_t1_l1, p2_t1_l1] (2 logs, same timestamp, 1 line each)" do
        CombinedLog.build_index([$pl_p1_t1_l1, $pl_p2_t1_l1]).to_a.should == $hash_p1_t1_l1_and_p2_t1_l1.to_a
      end
      it "handles [p1_t2_l1, p2_t1_l1] (2 logs, p2 timestamp comes before p1)" do
        CombinedLog.build_index([$pl_p1_t2_l1, $pl_p2_t1_l1]).to_a.should == $hash_p1_t2_l1_and_p2_t1_l1.to_a
      end


    end

    describe "#to_s" do
      it "prints p1_t1_l1_and_p2_t2_l1" do
        output = <<-eos
          #{$out_p1_t1_l1}
          #{$out_p2_t2_l1}
        eos
        CombinedLog.new([$pl_p1_t1_l1, $pl_p2_t2_l1]).to_s.should == output.unindent
      end

      end
    end
    end
  end
end


