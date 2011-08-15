source 'http://rubygems.org'

gem 'rails', '~> 3.1.0.rc5'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'mysql2'
#gem 'facter' # to detect number of cpus and system load
gem 'parallel' # just for Parallel.processor_count

gem 'exifr'
gem 'closure_tree' #, :git => 'git://github.com/mceachen/closure_tree.git'
gem 'rails3-settings', :git => 'git://github.com/mceachen/rails-settings.git', :require => 'settings'
#gem 'spawn', :git => 'git://github.com/rfc2822/spawn'
gem 'mini_magick', :git => 'git://github.com/hcatlin/mini_magick.git', :require => 'mini_gmagick'

gem 'delayed_job'
#gem 'delayed_job', :git => 'git://github.com/mceachen/delayed_job.git' # <-- this has prerequisites support
gem 'hirefire'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'sqlite3'
  # TODO:   gem 'webrat'
end
