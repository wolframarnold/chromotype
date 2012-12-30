Sidekiq.configure_server do |config|
  config.options[:concurrency] = Settings[:concurrency]
end