ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"
require 'minitest/reporters'
MiniTest::Reporters.use!

# Uncomment if you want Capybara in acceptance/integration tests
# require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
#require "minitest/pride"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |ea| require ea }

def img_path(basename)
  "#{File.dirname(__FILE__)}/images/#{basename}".to_pathname
end

# Do you want all existing Rails tests to use MiniTest::Rails?
# Comment out the following and either:
# A) Change the require on the existing tests to `require "minitest_helper"`
# B) Require this file's code in test_helper.rb

# MiniTest::Rails.override_testunit! # <- TODO: is this necessary?

require "mocha/setup"
