ActiveSupport.migration_safe_on_load do
  module Chromotype
    SHORT_TTL_CACHE = ActiveSupport::Cache::MemoryStore.new(
      :size => 32.megabytes,
      :max_prune_time => 60.seconds # <- long enough to prevent re-exiftool and URNing?
    )
    LONG_TTL_CACHE = ActiveSupport::Cache::FileStore.new(
      Settings.cache_root
    )
  end
end