module CacheSupport
  def cached_with_short_ttl(key, &block)
    Chromotype::SHORT_TTL_CACHE.fetch(cache_key(key)) { yield }
  end

  def cached_with_long_ttl(key, &block)
    Chromotype::LONG_TTL_CACHE.fetch(cache_key(key)) { yield }
  end

  def cache_key(key)
    "#{self.is_a? Class ? self : self.class}:#{key}"
  end
end