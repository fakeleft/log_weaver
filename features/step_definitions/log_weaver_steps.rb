require 'fileutils'

if ENV['FAILFAST']
  After do |s|
    Cucumber.wants_to_quit = true if s.failed?
  end
end

Given /^no file named "([^"]*)"$/ do |file_name|
  check_file_presence( [file_name], false )
end

Before do
  `rm -rf tmp`
end

