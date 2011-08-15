ActiveSupport.migration_safe_on_load do
  HireFire.configure do |config|
    config.environment = Settings[:hirefire_environment].to_sym
    config.min_workers = Settings[:hirefire_min_workers].to_i
    config.max_workers = Settings[:hirefire_max_workers].to_i
  end
end
