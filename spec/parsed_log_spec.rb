require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

#include LogWeaver::ParsedLog

module LogWeaver
  class ParsedLog
    describe "ParsedLog" do #seems to be needed for let
      describe ".parse_log" do
        it "parses single line with time stamp" do
          ParsedLog.parse_log($io_t1_l1).should == $hash_t1_l1
        end
        it "parses two lines with different time stamps" do
          ParsedLog.parse_log($io_t1_l1_t2_l1).should == $hash_t1_l1_t2_l1
        end
        it "handles lines with the same time stamp" do
          ParsedLog.parse_log($io_t1_l1_t1_l2).should == $hash_t1_l1_t1_l2
        end
        it "parses a log where the first line has no timestamp" do
          # TODO: subtract a ms from first time stamp?
          expect { ParsedLog.parse_log(@log_that_starts_with_no_timestamp) }.to raise_error ArgumentError, "Log does not begin with a timestamp."
        end
        it "associates lines with no timestamp with preceding timestamp" do
          ParsedLog.parse_log($io_t1_l1_no_t_l2).should == $hash_io_t1_l1_no_t_l2
        end
      end

      describe ".extract_time_stamp" do
        it "returns [nil, string] when string doesn't have a time stamp" do
          ParsedLog.extract_time_stamp("").should == [nil, ""]
          ParsedLog.extract_time_stamp("#{$no_t_line}").should == [nil, $no_t_line]
        end
        it "returns timestamp and a blank string when line contains only a timestamp" do
          ParsedLog.extract_time_stamp("#{$t.to_s}").should == [$t, ""]
        end
        it "returns a timestamp and message if the string begins with ISO-formatted time (including msecs)" do
          ParsedLog.extract_time_stamp("#{$t1_l1}").should == [$t1, $l1]
        end
        it "returns nil and the line when a line has a time stamp, but not at the beginning" do
          ParsedLog.extract_time_stamp("hello #{$t1}").should == [nil, "hello #{$t1}"]
          ParsedLog.extract_time_stamp("hello #{$t1_l1}").should == [nil, "hello #{$t1_l1}"]
        end
      end
    end
  end
end
