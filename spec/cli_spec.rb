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
    end
  end
end
