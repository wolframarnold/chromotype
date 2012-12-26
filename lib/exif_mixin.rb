require 'exiftoolr'

# Assumes the mixin consumer has a "pathname" method
module ExifMixin
  extend CacheSupport

  def self.cache
    Chromotype::SHORT_TTL_CACHE
  end

  # Returns hash of filename => Exiftoolr::Results for
  # all the files that have valid EXIF headers. Results
  # may be from cache.
  def self.exif_results *filenames
    results = {}
    filenames = filenames.collect { |ea| ea.to_s }
    filenames.each { |ea| results[ea] = cache.read(ea) }
    results.delete_if { |k, v| v.nil? || v.errors? }
    missing = filenames - results.keys
    e = Exiftoolr.new(missing)
    unless e.errors?
      missing.each do |ea|
        result = e.result_for(ea)
        cache.write(ea, result)
        results[ea] = result
      end
    end
    results
  end

  def self.exif_result filename
    f = filename.to_s
    exif_results(f)[f]
  end

  def exif_result
    @exif_result ||= ExifMixin.exif_result(pathname)
  end

  def exif?
    !exif_result.nil?
  end

  def exif
    exif_result.try(:to_hash)
  end

  def exif_display
    exif_result.try(:to_display_hash)
  end

  def image_pixels
    e = exif_result
    (e[:image_width].to_i * e[:image_height].to_i) unless e.nil?
  end

end
