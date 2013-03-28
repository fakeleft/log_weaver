require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module LogWeaver
  class CombinedLog
    describe "CombinedLog" do
      before(:all) do
        @p1 = "prefix1:"
        @p2 = "prefix2:"

        @t1 = Time.parse(Time.now.to_s)  # NOTE: init time this way to discard values below msec
        @t2 = @t1 + 1

        @t1l1 = "#{@t1} - t1 l1"
        @t1l2 = "#{@t1} - t1 l2"
        @t2l1 = "#{@t2} - t2 l1"
        @t2l2 = "#{@t2} - t2 l2"

        @no_t_line = "no t"

        @t1l1_parsed = "#{@p1}#{@t1l1}"
        @t2l1_parsed = "#{@p1}#{@t2l1}"

        @t1l1_log = StringIO.new(@t1l1)
        @t2l1_log = StringIO.new(@t2l1)

        @t1l1_t2l1_log = StringIO.new([@t1l1, @t2l1].join("\n"))
        @t1l2_t2l2_log = StringIO.new([@t1l2, @t2l2].join("\n"))

        @pl_p1_t1l1 = ParsedLog.new(@t1l1_log, @p1)
        @pl_p2_t1l1 = ParsedLog.new(@t1l1_log, @p2)

        @logs = [@pl_p1_t1l1, @pl_p2_t1l1]
        @cl = CombinedLog.new(@logs)
      end


      describe ".initialize" do
        it "stores the logs" do
          @cl.logs.should == @logs
        end
      end

    end
  end
end


