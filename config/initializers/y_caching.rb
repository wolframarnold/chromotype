ActiveSupport.migration_safe_on_load do
  module Chromotype
    SHORT_TTL_CACHE = ActiveSupport::Cache::MemoryStore.new(
      :size => 32.megabytes,
      :max_prune_time => 5.minutes # <- long enough to prevent re-exiftool and URNing?
    )
    LONG_TTL_CACHE = ActiveSupport::Cache::FileStore.new(
      Setting.cache_root,
      :max_prune_time => 1.month
    )
  end
end
