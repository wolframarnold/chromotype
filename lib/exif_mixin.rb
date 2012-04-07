require 'exiftoolr'

# Assumes the mixin consumer has a "pathname" method
module ExifMixin

  # re-using exif lookups when possible
  EXIF_RESULTS = Rufus::Lru::Hash.new(500)

  # Returns hash of filename => Exiftoolr::Results for
  # all the files that have valid EXIF headers. Results
  # may be from cache.
  def self.exif_results *filenames
    results = {}
    filenames = filenames.collect { |ea| ea.to_s }
    filenames.each { |ea| results[ea] = EXIF_RESULTS[ea] }
    results.delete_if { |k, v| v.nil? || v.errors? }
    missing = filenames - results.keys
    e = Exiftoolr.new(missing)
    missing.each do |ea|
      result = e.result_for(ea)
      EXIF_RESULTS[ea] = result
      results[ea] = result unless result.errors?
    end
    results
  end

  def exif_result
    @exif_result ||= begin
      p = pathname.to_s
      ExifMixin.exif_results(p)[p]
    end
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
