require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

#include LogWeaver::ParsedLog

module LogWeaver
  class ParsedLog
    describe "ParsedLog" do #seems to be needed for let
      before(:all) do
        @p1 = "prefix1:"
        @p2 = "prefix2:"

        @t1 = Time.parse(Time.now.to_s)  # NOTE: init time this way to discard values below msec
        @t2 = @t1 + 1

        @t1_l1 = "#{@t1} - t1 l1"
        @t1_l2 = "#{@t1} - t1 l2"
        @t2_l1 = "#{@t2} - t2 l1"
        @t2_l2 = "#{@t2} - t2 l2"
        @no_t_line = "no t"

        @t1_l1_parsed = "#{@p1}#{@t1_l1}"
        @t2_l1_parsed = "#{@p1}#{@t2_l1}"

        @empty_log                          = StringIO.new
        @t1l1_t2l1_log                      = StringIO.new([@t1_l1, @t2_l1].join("\n"))
        @t1l1_t2l1_log2                     = StringIO.new([@t1_l1, @t2_l1].join("\n"))
        @t1l2_t2l2_log                      = StringIO.new([@t1_l2, @t2_l2].join("\n"))
        @log_with_missing_timestamps        = StringIO.new([@t1_l1, @no_t_line, @t2_l1].join("\n"))
        @log_with_duplicate_timestamp       = StringIO.new([@t1_l1, @t1_l1].join("\n"))
        @log_that_starts_with_no_timestamp  = StringIO.new([@no_t_line, @t2_l1].join("\n"))

        @parsed_empty_log1       = ParsedLog.new(@empty_log, @p1)
        @parsed_empty_log2       = ParsedLog.new(@empty_log, @p1)
        @parsed_log_p1_t1l1_t2l1 = ParsedLog.new(@t1l1_t2l1_log, @p1)
        @parsed_log_p2_t1l1_t2l1 = ParsedLog.new(@t1l1_t2l1_log2, @p2)
        @parsed_log_p1_t1l2_t2l2 = ParsedLog.new(@t1l2_t2l2_log, @p1)
        @parsed_log_p2_t1l2_t2l2 = ParsedLog.new(@t1l2_t2l2_log, @p2)

        @k_p1_t1_1   = ParsedLogKey.new(@p1, @t1, 1)
        @k_p1_t1_2   = ParsedLogKey.new(@p1, @t1, 2)
        @k_p1_t2_1   = ParsedLogKey.new(@p1, @t2, 1)
        @k_p2_t1_1   = ParsedLogKey.new(@p2, @t1, 1)
        @k_p2_t2_1   = ParsedLogKey.new(@p2, @t2, 1)

        @lines  = { @k_p1_t1_1 => [@t1_l1] }
        @lines2 = { @k_p1_t2_1 => [@t2_l1] }

        @p1_t1_l1 = "#{@p1}#{@t1_l1}"
        @p1_t1_l2 = "#{@p1}#{@t1_l2}"
        @p1_t2_l1 = "#{@p1}#{@t2_l1}"
        @p1_t2_l2 = "#{@p1}#{@t2_l2}"
        @p2_t1_l1 = "#{@p2}#{@t1_l1}"
        @p2_t1_l2 = "#{@p2}#{@t1_l2}"
        @p2_t2_l1 = "#{@p2}#{@t2_l1}"
        @p2_t2_l2 = "#{@p2}#{@t2_l2}"

        @hashed_p1_t1l1_t2l1 = {
          @k_p1_t1_1 => [@t1_l1],
          @k_p1_t2_1 => [@t2_l1]
        }

        @hashed_p2_t1l2_t2l2 = {
          @k_p2_t1_1 => [@t1_l2],
          @k_p2_t2_1 => [@t2_l2]
        }

        @hashed_p1_t1l1_t2l1_plus_p2_t2l1_t2L2 = {
          @k_p1_t1_1 => [@p1_t1_l1],
          @k_p2_t1_1 => [@p2_t1_l2],
          @k_p1_t2_1 => [@p1_t2_l1],
          @k_p2_t2_1 => [@p2_t2_l2]
        }

        @hash_with_one_line_per_timestamp = {
          @k_p1_t1_1   => [@t1_l1_parsed],
          @k_p1_t2_1   => [@t2_l1_parsed]
        }

        @hash_with_duplicate_timestamps = {
          @k_p1_t1_1   => [@t1_l1_parsed],
          @k_p1_t1_2 => [@t1_l1_parsed]
        }

        @hash_with_more_than_one_line_per_timestamp = {
          @k_p1_t1_1  => [@t1_l1_parsed, @no_t_line],
          @k_p1_t2_1  => [@t2_l1_parsed]
        }
      end

      describe ".initialize" do
        it "stores the prefix" do
          @parsed_empty_log1.instance_variable_get(:@prefix).should == @p1
        end
        it "parses the given log file by timestamp" do
          @parsed_log_p1_t1l1_t2l1.instance_variable_get(:@lines).should == @hash_with_one_line_per_timestamp
        end
      end

      describe "#to_s" do
        it "prints the log to a string" do
          @parsed_empty_log1.stub(:lines).and_return(@lines)
          @parsed_empty_log1.to_s.should == @lines.map { |t, ls| ls.map { |l| "#{l}" }.join("\n") }.join("\n")
        end
      end

      describe "#+" do
        it "concatenates line hashes" do
          sum = @parsed_log_p1_t1l1_t2l1 + @parsed_log_p2_t1l2_t2l2
          sum.instance_variable_get(:@lines).should == @hashed_p1_t1l1_t2l1_plus_p2_t2l1_t2L2
        end
        it "concatenates and sorts line hashes" do
          @parsed_empty_log1.stub(:lines).and_return(@lines2)
          @parsed_empty_log2.stub(:lines).and_return(@lines)
          sum = @parsed_empty_log1 + @parsed_empty_log2
          sum.instance_variable_get(:@lines).to_a.should == (Hash[@lines.merge(@lines2).sort]).to_a
        end
        it "handles same timestamp across multiple files" do
          @parsed_log_p1_t1l1_t2l1.stub(:lines).and_return(@lines)
          @parsed_log_p2_t1l1_t2l1.stub(:lines).and_return(@lines)
          sum = @parsed_log_p1_t1l1_t2l1 + @parsed_log_p2_t1l1_t2l1
          sum.instance_variable_get(:@lines).to_a.should == (Hash[@lines.merge(@lines).sort]).to_a
        end
      end

      describe ".parse_log" do
        it "prepends the prefix to every line with a timestamp" do
          ParsedLog.parse_log(@t1l1_t2l1_log, @p1).should == @hash_with_one_line_per_timestamp
        end
        it "does not prepend the prefix to lines with no time stamp" do
          ParsedLog.parse_log(@log_with_missing_timestamps, @p1).should == @hash_with_more_than_one_line_per_timestamp
        end
        it "parses lines with different time stamps" do
          ParsedLog.parse_log(@t1l1_t2l1_log, @p1).should == @hash_with_one_line_per_timestamp
        end
        it "handles lines with the same time stamp" do
          ParsedLog.parse_log(@log_with_duplicate_timestamp, @p1).should == @hash_with_duplicate_timestamps
        end
        it "parses a log where the first line has no timestamp" do
          # TODO: subtract a ms from first time stamp?
          expect { ParsedLog.parse_log(@log_that_starts_with_no_timestamp) }.to raise_error ArgumentError, "Log does not begin with a timestamp."
        end
        it "associates lines with no timestamp with preceding timestamp " do
          ParsedLog.parse_log(@log_with_missing_timestamps, @p1).should == @hash_with_more_than_one_line_per_timestamp
        end
      end

      describe ".extract_time_stamp" do
        it "returns nil when string doesn't have a time stamp" do
          ParsedLog.extract_time_stamp("").should be_nil
          ParsedLog.extract_time_stamp("#{@no_t_line}").should be_nil
        end
        it "returns a timestamp if the string begins with ISO-formatted time (including msecs)" do
          ParsedLog.extract_time_stamp("#{@t1}").should == @t1
          ParsedLog.extract_time_stamp("#{@t1_l1}").should == @t1
        end
        it "returns nil when a string has a time stamp, but not at the beginning" do
          ParsedLog.extract_time_stamp("hello #{@t1}").should be_nil
          ParsedLog.extract_time_stamp("hello #{@t1_l1}").should be_nil
        end
      end
    end
  end
end
