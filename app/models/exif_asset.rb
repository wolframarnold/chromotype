class ExifAsset < Asset

  FILE_EXTENSIONS = %w{jpeg jpg 3fr ari arw bay cap cr2 crw dcr dcs dng drf eip erf fff iiq k25 kdc mef mos mrw nef nrw orf pef ptx pxn r3d raf raw rw2 rwl rwz sr2 srf srw x3f}

  def self.import_exif_file(filename)
    a = asset_for_file(filename, FILE_EXTENSIONS)
    return a if a == !!a # is boolean
    return false if a.exif.nil? # EXIF headers are mandatory.
    return false if (a.exif[:width] * a.exif[:height]) < Settings.minimum_image_pixels
    a.save! # So the processors have something persisted to associate to
    a.process
    a
  end

  def magick
    @magick ||= MiniMagick::Image.open uri
  end

  def captured_at
    exif[:date_time_original] || super
  end

  def gps_lat_lon
    return nil unless exif[:gps_latitude] && exif[:gps_longitude]
    [exif[:gps_latitude].to_f * (exif[:gps_latitude_ref] == 'S' ? -1 : 1),
      exif[:gps_longitude].to_f * (exif[:gps_longitude_ref] == 'W' ? -1 : 1)]
  end

  def self.exif(pathname)
    # try exiftool first, because it's AMAZING.
    @library_method ||= begin
      require 'mini_exiftool'
      self.method(:exiftool)
    rescue StandardError
      self.method(:exifr)
    end

    @library_method.call(pathname.to_pathname)
  end

  def self.exiftool(pathname)
    h = { }
    mini_exiftool = MiniExiftool.new(pathname.realpath.to_s)
    mini_exiftool.to_hash.each { |k, v| h[k.underscore.to_s] = v }
    h
  end

  def self.exifr(pathname)
    if %w{.jpeg .jpg}.include?(pathname.extname.downcase)
      begin
        return EXIFR::JPEG.new(pathname.to_s).to_hash
      rescue EXIFR::MalformedJPEG => e
        return nil
      end
    else
      # Try TIFF.
      begin
        EXIFR::TIFF.new(pathname.to_s).to_hash
      rescue EXIFR::MalformedTIFF => e
        return nil
      end
    end
  end

  def exif
    @exif ||= self.class.exif(pathname)
  end


  # Resize dimensions:
  #Square
  #  (75 x 75)
  #Thumbnail
  #(100 x 80)
  #Small
  #()
  #Medium 500
  #(400 x 400)
  #Medium 640
  #(800x800)
  #Large
  #(1200x1200)
  #Original
  #(2634 x 2105)

end
