require 'rubygems'
require 'spork'
require 'growl'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'


Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # Thanks, http://avdi.org/devblog/2011/04/17/rubymine-spork-rspec-cucumber/
  if ENV["RUBYMINE_HOME"]
    $:.unshift(File.expand_path("rb/testing/patch/common", ENV["RUBYMINE_HOME"]))
    $:.unshift(File.expand_path("rb/testing/patch/bdd", ENV["RUBYMINE_HOME"]))
  end

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'tmpdir'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.after :suite do
      r = config.reporter
      examples = r.instance_variable_get(:@example_count).to_i
      failures = r.instance_variable_get(:@failure_count).to_i
      opts = {:title => "Chromotype tests"}
      opts[:icon] = "spec/images/warning.png" if failures > 0
      msg = "#{examples} examples, #{failures} failures"
      Growl.notify msg, opts
    end
  end

  Webrat.configure do |config|
    config.mode = :rails
  end

  def with_tmp_dir(&block)
    cwd = Dir.pwd
    Dir.mktmpdir do |dir|
      Dir.chdir(dir)
      yield(dir)
    end
    Dir.chdir(cwd)
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end
