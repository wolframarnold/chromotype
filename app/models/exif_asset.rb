require 'exifr'

class ExifAsset < Asset

  FILE_EXTENSIONS = %w{jpeg jpg 3fr ari arw bay cap cr2 crw dcr dcs dng drf eip erf fff iiq k25 kdc mef mos mrw nef nrw orf pef ptx pxn r3d raf raw rw2 rwl rwz sr2 srf srw x3f}

  def self.import_exif_file(filename)
    a = asset_for_file(filename, FILE_EXTENSIONS)
    return a if a == !!a # is boolean
    return false if a.exif.nil? # EXIF headers are mandatory.
    a.save! # So the processors have something persisted to associate to
    a.process
    a
  end

  add_importer(ExifAsset.method("import_exif_file"), FILE_EXTENSIONS)

  def magick
    @magick ||= MiniMagick::Image.open uri
  end

  def captured_at
    exif.try(:date_time_original) || super
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
