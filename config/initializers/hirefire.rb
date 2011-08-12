HireFire.configure do |config|
  config.environment      = :local
  config.max_workers      = 2
  config.min_workers      = 0
  config.job_worker_ratio = [
      { :jobs => 1,   :workers => 1 },
      { :jobs => 10,  :workers => 2 }
    ]
end
