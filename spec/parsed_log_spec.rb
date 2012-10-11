require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'unindent'

#include LogWeaver::ParsedLog

class Time
  def to_s
    self.strftime("%Y-%m-%d %H:%M:%S.%L")
  end
end


module LogWeaver
  class ParsedLog

    describe "#to_s" do
      it "prints the log to a string" do
        now = Time.now
        prefix = "prefix"
        lines = { now => %w{ hello world } }
        p = ParsedLog.new(StringIO.new, "")
        p.stub(:lines).and_return(lines)
        p.stub(:prefix).and_return(prefix)
        p.to_s.should == lines.map{ |t, ls| "#{prefix}: #{t}" << " " << ls.map{ |l| "#{l}"}.join("\n")  << "\n"}
      end
    end

    describe ".initialize" do
      it "stores the prefix" do
        ParsedLog.new(StringIO.new, "prefix").instance_variable_get(:@prefix).should == "prefix"
      end
      let(:t) { Time.parse(Time.now.to_s) } # NOTE: init time this way to discard values below msec
      it "parses the given log file by timestamp" do
        log = StringIO.new(<<-file_contents.unindent
                                #{t} - hello
                                #{(t + 1)} - world
                              file_contents
                          )
        pl = ParsedLog.new log, "prefix"
        pl.instance_variable_get(:@lines).should == { t => ["#{t} - hello"], (t+1) => ["#{t+1} - world"]}

      end
    end

    describe ".parse_log" do
      let(:t) { Time.parse(Time.now.to_s) } # NOTE: init time this way to discard values below msec
      it "parses lines with different time stamps" do
        log = StringIO.new(<<-file_contents.unindent
                              #{t} - hello
                              #{(t + 1)} - world
                            file_contents
                          )
        ParsedLog.parse_log(log).should == { t => ["#{t} - hello"], (t+1) => ["#{t+1} - world"]}
      end
      it "parses a log where the first line has no timestamp" do
        # TODO: subtract a ms from first time stamp?
        log = StringIO.new(<<-file_contents.unindent
                              hello
                              #{(t + 1)} - world
        file_contents
        )
        expect{ ParsedLog.parse_log(log) }.to raise_error ArgumentError, "Log does not begin with a timestamp."
      end
      it "associates lines with no timestamp with preceding timestamp " do
        log = StringIO.new(<<-file_contents.unindent
                              #{t} - hello
                              hi
                              #{(t + 1)} - world
        file_contents
        )
        ParsedLog.parse_log(log).should == { t => ["#{t} - hello", "hi"], (t+1) => ["#{t+1} - world"]}
      end
    end

    describe ".extract_time_stamp"  do
      it "returns nil when string doesn't have a time stamp" do
        ParsedLog.extract_time_stamp("").should be_nil
        ParsedLog.extract_time_stamp("no timestamp here").should be_nil
      end
      it "returns a timestamp if the string begins with ISO-formatted time (including msecs)" do
        t = Time.parse(Time.now.to_s) #NOTE: spitting time to a string and then parsing to drop anything below msecs for later comparisons
        ParsedLog.extract_time_stamp("#{t}").should == t
        ParsedLog.extract_time_stamp("#{t} hello world").should == t
      end
      it "returns nil when a string has a time stamp, but not at the beginning" do
        t = Time.parse(Time.now.to_s)
        ParsedLog.extract_time_stamp("hello #{t}").should be_nil
        ParsedLog.extract_time_stamp("hello #{t} world").should be_nil
      end
    end

  end
end
