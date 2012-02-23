require 'exiftoolr'

class ExifAssetThumbprint < AssetThumbprint
  def self.thumbprint(pathname, exif_result = nil)
    exif_result ||= Exiftoolr.new(pathname).result_for(pathname)
    return nil if exif_result.errors?
    new(:thumbprint => mk_sha(exif_thumbprint_array(exif_result)))
  end

  # These fields are presumed to be highly unlikely to be changed when edited:
  def self.exif_thumbprint_array(exif)
    # Can't use :serial_number or :image_number because Preview.app deletes that tag.
    [exif[:create_date].to_i,
      exif[:f_number].to_s,
      exif[:iso].to_s,
      exif[:aperture].to_s,
      exif[:shutter_speed].to_s,
      exif[:make],
      exif[:model]] unless exif.nil?
  end
end
