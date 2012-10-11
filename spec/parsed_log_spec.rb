require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'unindent'

#include LogWeaver::ParsedLog

module LogWeaver
  class ParsedLog
    describe "ParsedLog" do #seems to be needed for let
      let(:prefix) {"prefix:"}

      let(:t1) { Time.parse(Time.now.to_s) } # NOTE: init time this way to discard values below msec
      let(:t2) { t1 + 1 }

      let(:t1_line) { "#{t1} - t1" }
      let(:t2_line) { "#{t2} - t2" }
      let(:no_t_line) { "no t" }

      let(:t1_parsed_line) { "#{prefix}#{t1_line}" }
      let(:t2_parsed_line) { "#{prefix}#{t2_line}" }

      let(:lines) { { t1 => [t1_line] } }
      let(:lines2) { { t2 => [t2_line] } }

      let(:empty_log) { StringIO.new }
      let(:fully_timestamped_log) { StringIO.new([t1_line, t2_line].join("\n")) }
      let(:log_with_lines_missing_timestamps) { StringIO.new([t1_line, no_t_line, t2_line].join("\n")) }
      let(:log_that_starts_with_no_timestamp) { StringIO.new([no_t_line, t2_line].join("\n")) }

      let(:parsed_empty_log1) { ParsedLog.new(empty_log, prefix) }
      let(:parsed_empty_log2) { ParsedLog.new(empty_log, prefix) }
      let(:parsed_fully_timestamped_log) { ParsedLog.new(fully_timestamped_log, prefix) }

      let(:hash_with_one_line_per_timestamp) { { t1 => [t1_parsed_line], t2 => [t2_parsed_line] } }
      let(:hash_with_more_than_one_line_per_timestamp) { { t1 => [t1_parsed_line, no_t_line], t2 => [t2_parsed_line] } }

      describe "#to_s" do
        it "prints the log to a string" do
          parsed_empty_log1.stub(:lines).and_return(lines)
          parsed_empty_log1.to_s.should == lines.map { |t, ls| ls.map { |l| "#{l}" }.join("\n") }.join("\n")
        end
      end

      describe "#+" do
        it "concatenates line hashes" do
          parsed_empty_log1.stub(:lines).and_return(lines)
          parsed_empty_log2.stub(:lines).and_return(lines2)
          sum = parsed_empty_log1 + parsed_empty_log2
          sum.instance_variable_get(:@lines).should == lines.merge(lines2)
        end
      end

      describe ".initialize" do
        it "stores the prefix" do
          parsed_empty_log1.instance_variable_get(:@prefix).should == prefix
        end
        it "parses the given log file by timestamp" do
          parsed_fully_timestamped_log.instance_variable_get(:@lines).should == hash_with_one_line_per_timestamp
        end
      end

      describe ".parse_log" do
        it "prepends the prefix to every line with a timestamp" do
          ParsedLog.parse_log(fully_timestamped_log, prefix).should == hash_with_one_line_per_timestamp
        end
        it "does not prepend the prefix to lines with no time stamp" do
          ParsedLog.parse_log(log_with_lines_missing_timestamps, prefix).should == hash_with_more_than_one_line_per_timestamp
        end
        it "parses lines with different time stamps" do
          ParsedLog.parse_log(fully_timestamped_log, prefix).should == hash_with_one_line_per_timestamp
        end
        it "parses a log where the first line has no timestamp" do
          # TODO: subtract a ms from first time stamp?
          expect { ParsedLog.parse_log(log_that_starts_with_no_timestamp) }.to raise_error ArgumentError, "Log does not begin with a timestamp."
        end
        it "associates lines with no timestamp with preceding timestamp " do
          ParsedLog.parse_log(log_with_lines_missing_timestamps, prefix).should == hash_with_more_than_one_line_per_timestamp
        end
      end

      describe ".extract_time_stamp" do
        it "returns nil when string doesn't have a time stamp" do
          ParsedLog.extract_time_stamp("").should be_nil
          ParsedLog.extract_time_stamp("#{no_t_line}").should be_nil
        end
        it "returns a timestamp if the string begins with ISO-formatted time (including msecs)" do
          ParsedLog.extract_time_stamp("#{t1}").should == t1
          ParsedLog.extract_time_stamp("#{t1_line}").should == t1
        end
        it "returns nil when a string has a time stamp, but not at the beginning" do
          ParsedLog.extract_time_stamp("hello #{t1}").should be_nil
          ParsedLog.extract_time_stamp("hello #{t1_line}").should be_nil
        end
      end
    end
  end
end
