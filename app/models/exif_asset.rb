class ExifAsset < Asset

  # Returns a string key to
  def features

  end

  def taken_at
    magick["exif:DateTimeDigitized"]
  end
  def camera_model
    magick["exif:Model"]
  end
  def iso_speed
    magick["exif:ISOSpeedRatings"]
  end
  def focal_length
    magick["exif:FocalLength"]
  end
  def exposure_time
    magick["exif:ExposureTime"]
  end
  def f_number
    magick["exif:FNumber"]
  end

  private

  def magick
    @magick ||= MiniMagick::Image.open uri
  end

  def exif
    @exif ||= EXIFR::JPEG.new uri.path
  end

  # Resize dimensions:
  #Square
  #  (75 x 75)
  #Thumbnail
  #(100 x 80)
  #Small
  #(240 x 192)
  #Medium 500
  #(500 x 399)
  #Medium 640
  #(640 x 511)
  #Large
  #(1024 x 818)
  #Original
  #(2634 x 2105)

end
