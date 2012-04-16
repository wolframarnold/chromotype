require 'exiftoolr'

# Assumes the mixin consumer has a "pathname" method
module ExifMixin

  CACHE = ActiveSupport::Cache.lookup_store(:memory_store)

  # Returns hash of filename => Exiftoolr::Results for
  # all the files that have valid EXIF headers. Results
  # may be from cache.
  def self.exif_results *filenames
    results = {}
    filenames = filenames.collect { |ea| ea.to_s }
    filenames.each { |ea| results[ea] = CACHE.read(ea) }
    results.delete_if { |k, v| v.nil? || v.errors? }
    missing = filenames - results.keys
    e = Exiftoolr.new(missing)
    missing.each do |ea|
      result = e.result_for(ea)
      CACHE.write(ea, result)
      results[ea] = result unless result.errors?
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
