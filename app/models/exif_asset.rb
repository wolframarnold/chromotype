class ExifAsset < FileAsset

  FILE_EXTENSIONS = %w{jpeg jpg 3fr ari arw bay cap cr2 crw dcr dcs dng drf eip erf fff iiq k25 kdc mef mos mrw nef nrw orf pef ptx pxn r3d raf raw rw2 rwl rwz sr2 srf srw x3f}

  def self.add_processor(method)
    (@processors ||= []) << method
  end

  def self.process_exif(filename)
    a = asset_for_file(filename, FILE_EXTENSIONS)
    return a if a == !!a # is boolean

    return false if a.exif.nil?

    @processors.each { |method| method.call(a) }
#* for that asset, extract features (like taken_date, gps, faces, ...)
#* tags are then find_or_created from those features
#* small, medium, large images are created (and large image uploaded to S3 for backup?)
    a
  end

  add_processor_method_for_extnames(ExifAsset.method("process_exif"), FILE_EXTENSIONS)

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

  def magick
    @magick ||= MiniMagick::Image.open uri
  end

  def exif
    @exif ||= begin
      if %w{.jpeg .jpg}.include?(pathname.extname.downcase)
        begin
          return EXIFR::JPEG.new pathname.to_s
        rescue EXIFR::MalformedJPEG => e
          return nil
        end
      else
        # Try TIFF.
        begin
          EXIFR::TIFF.new pathname.to_s
        rescue EXIFR::MalformedTIFF => e
          return nil
        end
      end
    end
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
