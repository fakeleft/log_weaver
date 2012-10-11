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
        it "should handle file names shorter than min length" do
          get_file_prefixes(%w{ 12345 f }).should == { "12345" => "1234", "f" => "f" }
          get_file_prefixes(%w{ f 12345 }).should == { "f" => "f", "12345" => "1234" }
        end
        it "should respond to the min_length param" do
          get_file_prefixes(%w{ 12345 abc f }, 3).should == { "12345" => "123", "abc" => "abc", "f" => "f" }
        end
      end
      context "file names share a prefix" do
        it "should get prefix for files longer than default min_length" do
          get_file_prefixes(%w{ 12345 1234a }).should == { "12345" => "12345", "1234a" => "1234a" }
        end
        it "should get prefix for files shorter than default min_length" do
          get_file_prefixes(%w{ 123 12a }).should == { "123" => "123", "12a" => "12a" }
        end
        it "should get prefix for a mix of file name lengths" do
          get_file_prefixes(%w{ 12345 a 1234 }).should == { "12345" => "12345", "a" => "a", "1234" => "1234" }
        end
      end
      context "file names are the same" do
        it "should prepend the directory portion of the path" do
          get_file_prefixes(%w{ a/a b/a }).should == { "a/a" => "a/a", "b/a" => "b/a" }
          get_file_prefixes(%w{ a/b/a b/c/a }).should == { "a/b/a" => "b/a", "b/c/a" => "c/a" }
          get_file_prefixes(%w{ a/a a/../b/a }).should == { "a/a" => "a/a", "a/../b/a" => "b/a" }
          get_file_prefixes(%w{ a/a b/a c/a}).should == { "a/a" => "a/a", "b/a" => "b/a", "c/a" => "c/a" }
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
