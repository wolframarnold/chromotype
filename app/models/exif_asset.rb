class ExifAsset < FileAsset
  class << self
    def import file

    end

    def can_import? file
      file = Pathname.as_path file
      ext = file.extname
      file.to_s
    end
      EXIFR::JPEG.new('IMG_3422.JPG').
    end
  end
end
