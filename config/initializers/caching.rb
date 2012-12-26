module Chromotype
  SHORT_TTL_CACHE = ActiveSupport::Cache.lookup_store(
    :memory_store,
    :size => 32.megabytes,
    :max_prune_time => 20.seconds
  )
  LONG_TTL_CACHE = ActiveSupport::Cache.lookup_store(
    :file_store,
    Settings.cache_root
  )
end