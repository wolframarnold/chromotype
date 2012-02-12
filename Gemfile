source 'http://rubygems.org'

gem 'rails', '>= 3.2'

gem 'thin'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails' #,   '~> 3.1.4'
  gem 'coffee-rails' #, '~> 3.1.1'
  gem 'uglifier' #, '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby' #, '~> 3.0.0'

gem 'guard' # file alteration monitoring
gem 'rb-inotify', :require => false
gem 'rb-fsevent', :require => false
gem 'rb-fchange', :require => false

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'mysql2'
gem 'pg'
gem 'sqlite3'
gem 'haml-rails'

#gem 'facter' # to detect number of cpus and system load
gem 'parallel' # just for Parallel.processor_count

gem 'ruby-geonames', :git => 'https://github.com/mceachen/ruby-geonames.git'

gem 'exifr' # extracts gps information that `identify` doesn't
gem 'findler' #, :git => 'git://github.com/mceachen/findler.git'
gem 'closure_tree' #, :git => 'git://github.com/mceachen/closure_tree.git'
gem 'ledermann-rails-settings', :require => 'rails-settings'
#gem 'spawn', :git => 'git://github.com/rfc2822/spawn'
gem 'mini_magick', :git => 'https://github.com/mceachen/mini_magick.git', :require => 'mini_gmagick'
# TODO: gem 'geokit-rails'

gem 'delayed_job_active_record'
#gem 'delayed_job', :git => 'git://github.com/mceachen/delayed_job.git' # <-- this has prerequisites support
gem 'hirefire'

group :test do
  gem 'autotest'
  gem 'spork'
  gem 'autotest-rails-pure'
  gem 'autotest-fsevent'
  gem 'autotest-growl'
  gem 'rspec', '~> 2.7.0'
  gem 'rspec-rails'
  gem 'webrat'
  gem 'database_cleaner' #TODO: needed?
  gem 'factory_girl_rails' #TODO: needed?
end
