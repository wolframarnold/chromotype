require 'exiftoolr'

module Exiffed

  attr_writer :exiftoolr

  def exiftoolr
    @exiftoolr ||= Exiftoolr.new(self.pathname.to_s)
  end

  def exif_result
    r = exiftoolr.result_for(pathname)
    r unless r.errors?
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
