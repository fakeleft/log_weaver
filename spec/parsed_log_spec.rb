require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

#include LogWeaver::ParsedLog

module LogWeaver
  class ParsedLog
    describe "ParsedLog" do #seems to be needed for let
      let(:prefix1) {"prefix1:"}
      let(:prefix2) {"prefix2:"}

      let(:t1) { Time.parse(Time.now.to_s) } # NOTE: init time this way to discard values below msec
      let(:t2) { t1 + 1 }

      let(:t1_l1) { "#{t1} - t1 l1" }
      let(:t1_l2) { "#{t1} - t1 l2" }
      let(:t2_l1) { "#{t2} - t2 l1" }
      let(:t2_l2) { "#{t2} - t2 l2" }
      let(:no_t_line) { "no t" }

      let(:t1_l1_parsed) { "#{prefix1}#{t1_l1}" }
      let(:t2_l1_parsed) { "#{prefix1}#{t2_l1}" }

      let(:k1) { ParsedLogKey.new(prefix1, t1, 1) }
      let(:k1_2) { ParsedLogKey.new(prefix1, t1, 2) }
      let(:k2) { ParsedLogKey.new(prefix1, t2, 1) }
      let(:lines) { { k1 => [t1_l1] } }
      let(:lines2) { { k2 => [t2_l1] } }

      let(:empty_log) { StringIO.new }
      let(:fully_timestamped_log) { StringIO.new([t1_l1, t2_l1].join("\n")) }
      let(:fully_timestamped_log_clone) { StringIO.new([t1_l1, t2_l1].join("\n")) }
      let(:fully_timestamped_log2) { StringIO.new([t1_l2, t2_l2].join("\n")) }
      let(:log_with_missing_timestamps) { StringIO.new([t1_l1, no_t_line, t2_l1].join("\n")) }
      let(:log_with_duplicate_timestamp) { StringIO.new([t1_l1, t1_l1].join("\n")) }
      let(:log_that_starts_with_no_timestamp) { StringIO.new([no_t_line, t2_l1].join("\n")) }

      let(:parsed_empty_log1) { ParsedLog.new(empty_log, prefix1) }
      let(:parsed_empty_log2) { ParsedLog.new(empty_log, prefix1) }
      let(:parsed_fully_timestamped_log) { ParsedLog.new(fully_timestamped_log, prefix1) }
      let(:parsed_fully_timestamped_log_clone) { ParsedLog.new(fully_timestamped_log_clone, prefix2) }
      let(:parsed_fully_timestamped_log2) { ParsedLog.new(fully_timestamped_log2, prefix1) }

      let(:hash_with_one_line_per_timestamp) { { k1 => [t1_l1_parsed], k2 => [t2_l1_parsed] } }
      let(:hash_with_duplicate_timestamps) { { k1 => [t1_l1_parsed], k1_2 => [t1_l1_parsed] } }
      let(:hash_with_more_than_one_line_per_timestamp) { { k1 => [t1_l1_parsed, no_t_line], k2 => [t2_l1_parsed] } }

      describe ".initialize" do
        it "stores the prefix" do
          parsed_empty_log1.instance_variable_get(:@prefix).should == prefix1
        end
        it "parses the given log file by timestamp" do
          parsed_fully_timestamped_log.instance_variable_get(:@lines).should == hash_with_one_line_per_timestamp
        end
      end

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
          sum.instance_variable_get(:@lines).to_a.should == (Hash[lines.merge(lines2).sort]).to_a
        end
        it "concatenates and sorts line hashes" do
          parsed_empty_log1.stub(:lines).and_return(lines2)
          parsed_empty_log2.stub(:lines).and_return(lines)
          sum = parsed_empty_log1 + parsed_empty_log2
          sum.instance_variable_get(:@lines).to_a.should == (Hash[lines.merge(lines2).sort]).to_a
        end
        it "handles same timestamp across multiple files" do
          parsed_fully_timestamped_log.stub(:lines).and_return(lines)
          parsed_fully_timestamped_log_clone.stub(:lines).and_return(lines)
          sum = parsed_fully_timestamped_log + parsed_fully_timestamped_log_clone
          sum.instance_variable_get(:@lines).to_a.should == (Hash[lines.merge(lines).sort]).to_a
        end
      end

      describe ".parse_log" do
        it "prepends the prefix to every line with a timestamp" do
          ParsedLog.parse_log(fully_timestamped_log, prefix1).should == hash_with_one_line_per_timestamp
        end
        it "does not prepend the prefix to lines with no time stamp" do
          ParsedLog.parse_log(log_with_missing_timestamps, prefix1).should == hash_with_more_than_one_line_per_timestamp
        end
        it "parses lines with different time stamps" do
          ParsedLog.parse_log(fully_timestamped_log, prefix1).should == hash_with_one_line_per_timestamp
        end
        it "handles lines with the same time stamp" do
          ParsedLog.parse_log(log_with_duplicate_timestamp, prefix1).should == hash_with_duplicate_timestamps
        end
        it "parses a log where the first line has no timestamp" do
          # TODO: subtract a ms from first time stamp?
          expect { ParsedLog.parse_log(log_that_starts_with_no_timestamp) }.to raise_error ArgumentError, "Log does not begin with a timestamp."
        end
        it "associates lines with no timestamp with preceding timestamp " do
          ParsedLog.parse_log(log_with_missing_timestamps, prefix1).should == hash_with_more_than_one_line_per_timestamp
        end
      end

      describe ".extract_time_stamp" do
        it "returns nil when string doesn't have a time stamp" do
          ParsedLog.extract_time_stamp("").should be_nil
          ParsedLog.extract_time_stamp("#{no_t_line}").should be_nil
        end
        it "returns a timestamp if the string begins with ISO-formatted time (including msecs)" do
          ParsedLog.extract_time_stamp("#{t1}").should == t1
          ParsedLog.extract_time_stamp("#{t1_l1}").should == t1
        end
        it "returns nil when a string has a time stamp, but not at the beginning" do
          ParsedLog.extract_time_stamp("hello #{t1}").should be_nil
          ParsedLog.extract_time_stamp("hello #{t1_l1}").should be_nil
        end
      end
    end
  end
end
