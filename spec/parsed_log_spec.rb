require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'unindent'

#include LogWeaver::ParsedLog

module LogWeaver
  class ParsedLog
    describe "ParsedLog" do #seems to be needed for let
      let(:t1) { Time.parse(Time.now.to_s) } # NOTE: init time this way to discard values below msec
      let(:prefix) {"prefix:"}

      describe "#to_s" do
        it "prints the log to a string" do
          lines = { t1 => ["#{prefix}#{t1} - hello"] }
          p = ParsedLog.new(StringIO.new, prefix)
          p.stub(:lines).and_return(lines)
          p.to_s.should == lines.map { |t, ls| ls.map { |l| "#{l}" }.join("\n") }.join("\n")
        end
      end

      describe "#+" do
        it "concatenates line hashes" do
          lines = { t1 => ["#{t1} - hello"] }
          p = ParsedLog.new(StringIO.new, "")
          p.stub(:lines).and_return(lines)
          lines2 = { t1 + 1 => ["#{t1 + 1} - world"] }
          p2 = ParsedLog.new(StringIO.new, "")
          p2.stub(:lines).and_return(lines2)
          sum = p + p2
          sum.instance_variable_get(:@lines).should == lines.merge(lines2)
        end
      end

      describe ".initialize" do
        it "stores the prefix" do
          ParsedLog.new(StringIO.new, "prefix").instance_variable_get(:@prefix).should == "prefix"
        end

        it "parses the given log file by timestamp" do
          log = StringIO.new(<<-file_contents.unindent
                                  #{t1} - hello
                                  #{(t1 + 1)} - world
                                file_contents
                            )
          pl = ParsedLog.new log, "prefix"
          pl.instance_variable_get(:@lines).should == { t1 => ["prefix#{t1} - hello"], (t1+1) => ["prefix#{t1+1} - world"] }

        end
      end

      describe ".parse_log" do
        it "prepends the prefix to every line with a timestamp" do
          log = StringIO.new(<<-file_contents.unindent
                                  #{t1} - hello
                                  #{(t1 + 1)} - world
                                file_contents
                            )
          ParsedLog.parse_log(log, prefix).should == { t1 => ["#{prefix}#{t1} - hello"], (t1+1) => ["#{prefix}#{t1+1} - world"] }
        end
        it "does not prepend the prefix to lines with no time stamp" do
          log = StringIO.new(<<-file_contents.unindent
                                  #{t1} - hello
                                  hi
                                  #{(t1 + 1)} - world
                                file_contents
                            )
          ParsedLog.parse_log(log, prefix).should == { t1 => ["#{prefix}#{t1} - hello", "hi"], (t1+1) => ["#{prefix}#{t1+1} - world"] }
        end
        it "parses lines with different time stamps" do
          log = StringIO.new(<<-file_contents.unindent
                                  #{t1} - hello
                                  #{(t1 + 1)} - world
                                file_contents
                            )
          ParsedLog.parse_log(log).should == { t1 => ["#{t1} - hello"], (t1+1) => ["#{t1+1} - world"] }
        end
        it "parses a log where the first line has no timestamp" do
          # TODO: subtract a ms from first time stamp?
          log = StringIO.new(<<-file_contents.unindent
                                  hello
                                  #{(t1 + 1)} - world
                                file_contents
                            )
          expect { ParsedLog.parse_log(log) }.to raise_error ArgumentError, "Log does not begin with a timestamp."
        end
        it "associates lines with no timestamp with preceding timestamp " do
          log = StringIO.new(<<-file_contents.unindent
                                  #{t1} - hello
                                  hi
                                  #{(t1 + 1)} - world
                                file_contents
                            )
          ParsedLog.parse_log(log).should == { t1 => ["#{t1} - hello", "hi"], (t1+1) => ["#{t1+1} - world"] }
        end
      end

      describe ".extract_time_stamp" do
        it "returns nil when string doesn't have a time stamp" do
          ParsedLog.extract_time_stamp("").should be_nil
          ParsedLog.extract_time_stamp("no timestamp here").should be_nil
        end
        it "returns a timestamp if the string begins with ISO-formatted time (including msecs)" do
          t = Time.parse(Time.now.to_s) #NOTE: spitting time to a string and then parsing to drop anything below msecs for later comparisons
          ParsedLog.extract_time_stamp("#{t1}").should == t1
          ParsedLog.extract_time_stamp("#{t1} hello world").should == t1
        end
        it "returns nil when a string has a time stamp, but not at the beginning" do
          t1 = Time.parse(Time.now.to_s)
          ParsedLog.extract_time_stamp("hello #{t1}").should be_nil
          ParsedLog.extract_time_stamp("hello #{t1} world").should be_nil
        end
      end
    end
  end
end
