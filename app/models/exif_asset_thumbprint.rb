class ExifAssetThumbprint < AssetThumbprint
  def self.thumbprint(pathname)
    if exif = ExifAsset.exif(pathname)
      # These fields are presumed to be highly unlikely to be changed when edited:
      new(:thumbprint => self.mk_sha([exif[:make],
        exif[:model],
        exif[:]
        exif[:f_number],
        exif[:aperture_value],
        exif[:shutter_speed_value],
        exif[:iso_speed_ratings],
        exif[:date_time_original]
      ]))
    end
  end
end
