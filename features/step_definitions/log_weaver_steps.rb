require 'fileutils'

Given /^no file named "([^"]*)"$/ do |file_name|
  check_file_presence( [file_name], false )
end

Before do
  `rm -rf tmp`
end

