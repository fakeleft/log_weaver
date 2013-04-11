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
        CombinedLog.build_index([$pl_p1_t1_l1, $pl_p2_t2_l1]).should == $hash_p1_t1_l1_and_p2_t2_l1
      end
      it "handles [p1_t1_l1, p2_t1_l1] (2 logs, same timestamp, 1 line each)" do
        CombinedLog.build_index([$pl_p1_t1_l1, $pl_p2_t1_l1]).should == $hash_p1_t1_l1_and_p2_t1_l1
      end
    end

    describe "#to_s" do
      it "prints 2 simplest logs" do
        output = <<-eos
          #{@p1_t1l1_parsed}
          #{@p2_t2l1_parsed}
        eos

        @cl.to_s.should ==  output.unindent
      end
    end
    end
  end
end


