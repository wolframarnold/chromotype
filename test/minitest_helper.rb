require "minitest/spec"
require 'minitest/reporters'
require "minitest/autorun"

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

MiniTest::Unit.runner = MiniTest::SuiteRunner.new
if ENV["RM_INFO"] || ENV["TEAMCITY_VERSION"]
  MiniTest::Unit.runner.reporters << MiniTest::Reporters::RubyMineReporter.new
elsif ENV['TM_PID']
  MiniTest::Unit.runner.reporters << MiniTest::Reporters::RubyMateReporter.new
else
  MiniTest::Unit.runner.reporters << MiniTest::Reporters::ProgressReporter.new
end

def with_tmp_dir(&block)
  cwd = Dir.pwd
  Dir.mktmpdir do |dir|
    Dir.chdir(dir)
    yield(dir)
  end
  Dir.chdir(cwd)
end
