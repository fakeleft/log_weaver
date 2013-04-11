require 'spec_helper'
require 'unindent'

module LogWeaver
  class CombinedLog
    describe "CombinedLog" do
      before(:all) do
      end


      describe ".initialize" do
        it "stores the logs" do
          @cl.logs.should == @logs
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


