require 'exiftoolr'

class ExifAssetThumbprint < AssetThumbprint
  class ExifTarget
    attr_accessor :pathname
    include ExifMixin
    def initialize(pathname)
      @pathname = pathname
    end
  end

  def self.thumbprint(pathname, exif_result = nil)
    new(:thumbprint => mk_sha1(exif_thumbprint_array(pathname, exif_result)))
  end

  def self.thumbprint_for_asset(exif_asset)
    mk_sha1(exif_thumbprint_array(exif_asset.pathname, exif_asset.exif_result))
  end

  # These fields are presumed to be highly unlikely to be changed when edited:
  def self.exif_thumbprint_array(pathname, exif_result = nil)
    exif_result ||= ExifTarget.new(pathname).exif_result
    return nil if exif_result.errors?

    # Can't use :serial_number or :image_number because Preview.app deletes that tag.
    [exif_result[:create_date].to_i,
      exif_result[:f_number].to_s,
      exif_result[:iso].to_s,
      exif_result[:aperture].to_s,
      exif_result[:shutter_speed].to_s,
      exif_result[:make],
      exif_result[:model]]
  end
end
