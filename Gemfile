source 'https://rubygems.org'

gem 'rails', '3.2.1'

gem 'thin'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'mysql2'
gem 'pg'

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails' #,   '~> 3.2.3'
  gem 'coffee-rails' #, '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

gem 'guard' # file alteration monitoring
gem 'rb-inotify', :require => false
gem 'rb-fsevent', :require => false
gem 'rb-fchange', :require => false

# gem 'haml-rails'
gem 'parallel' # just for Parallel.processor_count
gem 'ruby-geonames', :git => 'https://github.com/mceachen/ruby-geonames.git'
gem 'findler' #, :git => 'git://github.com/mceachen/findler.git'
gem 'closure_tree' #, :git => 'git://github.com/mceachen/closure_tree.git'
gem 'exiftoolr' #, :git => 'git://github.com/mceachen/exiftoolr.git'
gem 'ledermann-rails-settings', :require => 'rails-settings'
#gem 'spawn', :git => 'git://github.com/rfc2822/spawn'
gem 'mini_magick', :git => 'https://github.com/mceachen/mini_magick.git', :require => 'mini_gmagick'

gem 'delayed_job_active_record'
#gem 'delayed_job', :git => 'git://github.com/mceachen/delayed_job.git' # <-- this has prerequisites support
gem 'hirefire'
gem 'nokogiri'

#group :test do
  #gem 'rspec', '~> 2.7.0'
  #gem 'rspec-rails'
  #gem 'webrat'
  #gem 'watchr' # See http://www.rubyinside.com/how-to-rails-3-and-rspec-2-4336.html
  #gem 'spork'
  #gem 'growl', :require => false
  #gem 'autotest'
  #gem 'autotest-rails-pure'
  #gem 'autotest-fsevent'
  #gem 'autotest-growl'
  #gem 'database_cleaner' #TODO: needed?
  #gem 'factory_girl_rails' #TODO: needed?
#end

group :test, :development do
  gem 'minitest' # At least v2.0.2 if using MiniShoulda.
  gem 'minitest-rails', :git => "git@github.com:rawongithub/minitest-rails.git", :branch => "gemspec"
  gem 'minitest-reporters'
  #gem 'mini_backtrace' # Use Rails.backtrace_cleaner with MiniTest.
  gem 'mini_shoulda' # A small Shoulda syntax on top of MiniTest::Spec.
end
