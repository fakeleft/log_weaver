require 'spec_helper'
require 'unindent'

module LogWeaver

  def index(logs)
    CombinedLog.new(logs).instance_variable_get(:index)
  end


  describe CombinedLog do
=begin
    before(:all) do
    end


    describe ".initialize" do
      it "stores the logs" do
        @cl.logs.should == @logs
      end
    end
=end

    describe ".build_index" do
      # note: it's much briefer/easier/more readable to give symbolic descriptions
      # for the examples; pn is the prefix, tn is the timestamp, ln are the line contents
=begin
      it "handles [p1_t1_l1, p2_t2_l1] (2 logs, ordered timestamps, 1 line each)" do
        CombinedLog.build_index([$pl_p1_t1_l1, $pl_p2_t2_l1]).to_a.should == $hash_p1_t1_l1_and_p2_t2_l1.to_a
      end
      it "handles [p1_t1_l1, p2_t1_l1] (2 logs, same timestamp, 1 line each)" do
        CombinedLog.build_index([$pl_p1_t1_l1, $pl_p2_t1_l1]).to_a.should == $hash_p1_t1_l1_and_p2_t1_l1.to_a
      end
      it "handles [p1_t2_l1, p2_t1_l1] (2 logs, p2 timestamp comes before p1)" do
        CombinedLog.build_index([$pl_p1_t2_l1, $pl_p2_t1_l1]).to_a.should == $hash_p1_t2_l1_and_p2_t1_l1.to_a
      end


      sum = @parsed_log_p1_t1l1_t2l1 + @parsed_log_p1_t1l2_t2l2
      sum = @parsed_log_p1_t2l1 + @parsed_log_p2_t1l1
      sum = @parsed_log_p1_t1l1_t2l1 + @parsed_log_p2_t1l1_t2l1
      it "handles [p1_t2_l1, p2_t1_l1] (2 logs, p2 timestamp comes before p1)" do
        cl = CombinedLog.build_index([$pl_p1_t2_l1, $pl_p2_t1_l1])
        cl.should == $hash_p1_t2_l1_and_p2_t1_l1
        CombinedLog.build_index([$pl_p1_t2_l1, $pl_p2_t1_l1]).to_a.should == $hash_p1_t2_l1_and_p2_t1_l1.to_a
      end
=end
    end

    describe "#to_s" do
      it "prints p1_t1_l1_and_p2_t2_l1" do
        output = <<-eos
          #{$out_p1_t1_l1}
          #{$out_p2_t2_l1}
        eos
        CombinedLog.new([$pl_p1_t1_l1, $pl_p2_t2_l1]).to_s.should == output.unindent
      end

      it "prints p1_t1_l1_t2_l1_and_p2_t3_l1" do
        output = <<-eos
          #{$out_p1_t1_l1}
          #{$out_p1_t2_l1}
          #{$out_p2_t3_l1}
        eos
        CombinedLog.new([$pl_p1_t1_l1_t2_l1, $pl_p2_t3_l1]).to_s.should == output.unindent
      end
=begin
      # from parsed_log_spec
      it "prepends the prefix to every line with a timestamp" do
        ParsedLog.parse_log(@t1l1_t2l1_log, @p1).should == @hash_with_one_line_per_timestamp
      end
      it "does not prepend the prefix to lines with no time stamp" do
        ParsedLog.parse_log(@log_with_missing_timestamps, @p1).should == @hash_with_more_than_one_line_per_timestamp
      end
=end
    end
  end
end


