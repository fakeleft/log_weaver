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
        p = ParsedLog.new(nil, nil)
        p.stub(:lines).and_return(lines)
        p.stub(:prefix).and_return(prefix)
        p.to_s.should == lines.map{ |t, ls| "#{prefix}: #{t}" << " " << ls.map{ |l| "#{l}"}.join("\n")  << "\n"}
      end
    end

    describe "#initialize" do
      it "stores the prefix" do
        ParsedLog.new( nil, "prefix").instance_variable_get(:@prefix).should == "prefix"
      end
      it "parses the given log file by timestamp" do
        t = Time.now
        log = StringIO.new(<<-file_contents.unindent
                                #{t} - hello
                                #{(t + 1)} - world
                              file_contents
                          )
        pl = ParsedLog.new log, "prefix"
        pl.instance_variable_get(:@lines).should == { t => [" - hello"], (t+1) => [" - world"]}

      end
    end
    describe ".parse_log" do
      it "parses lines with different time stamps" do
        t = Time.now
        log = StringIO.new(<<-file_contents.unindent
                              #{t} - hello
                              #{(t + 1)} - world
                            file_contents
                          )
        ParsedLog.parse_log(log).should == { t => [" - hello"], (t+1) => [" - world"]}
      end
    end

  end
end
