ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/great_expectations"
require "minitest/autorun"
require "minitest/rails"
require 'minitest/reporters'
MiniTest::Reporters.use!
require 'sidekiq/testing'

# Uncomment if you want Capybara in acceptance/integration tests
# require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
# require "minitest/pride"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |ea| require ea }

DatabaseCleaner.strategy = :transaction
class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end
  after :each do
    DatabaseCleaner.clean
  end
end

def img_path(basename)
  "#{File.dirname(__FILE__)}/images/#{basename}".to_pathname
end

def with_tmp_dir(&block)
  cwd = Dir.pwd
  Dir.mktmpdir do |dir|
    Dir.chdir(dir)
    yield(Pathname.new dir)
    Dir.chdir(cwd) # jruby needs us to cd out of the tmpdir so it can remove it
  end
ensure
  Dir.chdir(cwd)
end

# MiniTest::Rails.override_testunit! # <- TODO: is this necessary?

require "mocha/setup"
