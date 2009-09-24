$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), "..", "..", "lib"))

require 'rubygems'
require 'test/unit'

if RUBY_VERSION =~ /^1\.9/
  puts "\nRunning the unit test suite doesn't as of yet work with Ruby 1.9, because Mocha hasn't yet been updated to use minitest."
  puts
  exit 1
end

require 'mocha'
gem 'thoughtbot-shoulda'
require 'shoulda'
