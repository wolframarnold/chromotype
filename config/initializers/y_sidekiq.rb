Sidekiq.configure_server do |config|
  config.options[:concurrency] = Settings[:concurrency]
  config.options[:queues] << :default
  config.options[:queues] << :user
end