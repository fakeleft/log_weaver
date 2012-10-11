require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include LogWeaver::CLI

module LogWeaver
  module CLI

    describe "#get_file_prefixes", wip: true do
      context "file names don't share a prefix" do
        it "should use a min_length of 4 by default" do
          get_file_prefixes(%w{ 12345 abcde }).should == { "12345" => "1234", "abcde" => "abcd" }
          get_file_prefixes(%w{ 12345 abcd  }).should == { "12345" => "1234", "abcd"  => "abcd" }
          get_file_prefixes(%w{ 1234  abcde }).should == { "1234"  => "1234", "abcde" => "abcd" }
          get_file_prefixes(%w{ 1234  abcd  }).should == { "1234"  => "1234", "abcd"  => "abcd" }
          get_file_prefixes(%w{ 12345 abcde 54321 }).should == { "12345" => "1234", "abcde" => "abcd", "54321" => "5432" }
        end


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
