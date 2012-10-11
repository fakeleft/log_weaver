require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'unindent'

#include LogWeaver::ParsedLog

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
        p.to_s.should == lines.map{ |t, ls| "#{prefix}: #{t.strftime("%Y-%m-%d %H:%M:%S.%L")}" << " " << ls.map{ |l| "#{l}"}.join("\n")  << "\n"}
      end
    end
    describe "#initialize" do
      it "parses the given log file by timestamp" do
        now = Time.now
        log = StringIO.new(<<-file_contents.unindent
                                #{now.strftime("%Y-%m-%d %H:%M:%S.%L")} - hello
                                #{(now + 1).strftime("%Y-%m-%d %H:%M:%S.%L")} - world
                              file_contents
                          )

        puts log.string
      end

    end
  end
end
