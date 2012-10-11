require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include LogWeaver::CLI

module LogWeaver
  module CLI

    describe "#get_file_prefixes" do
      it "should return whole file name if shorter than PREFIX_LENGTH_LIMIT and file name trimmed to PREFIX_LENGTH_LIMIT characters if longer than PREFIX_LENGTH_LIMIT" do
        get_file_prefixes("fil", "file2").should == ["fil", "file"]

      end

    end

    describe "#get_longest_common_prefix" do
      it "should return nil if one of the strings is nil" do
        get_longest_common_prefix([nil]).should be_nil
        get_longest_common_prefix(["", nil]).should be_nil
        get_longest_common_prefix(["a", nil]).should be_nil
        get_longest_common_prefix(["a", nil, ""]).should be_nil
        get_longest_common_prefix(["a", nil, "b"]).should be_nil
      end

      it "should return a blank string if there is no common prefix" do
        get_longest_common_prefix(%w{ a b }).should == ""
        get_longest_common_prefix(%w{ aa ba }).should == ""
        get_longest_common_prefix(%w{ aa ba a }).should == ""
        get_longest_common_prefix(%w{ a ba aa }).should == ""
      end

      it "should return the longest common prefix if there is one" do
        get_longest_common_prefix(%w{ a }).should == "a"
        get_longest_common_prefix(%w{ a ab }).should == "a"
        get_longest_common_prefix(%w{ aa aab }).should == "aa"
        get_longest_common_prefix(%w{ a aa aa }).should == "a"
        get_longest_common_prefix(%w{ aa aa a }).should == "a"
      end

      it "should not change any of its arguments" do
        a = %w{ 12345 abcde }
        get_longest_common_prefix( a )
        a.should == %w{ 12345 abcde }
      end

    end
  end
end
