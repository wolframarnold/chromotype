require 'fileutils'

class ExifAsset < Asset
  include ExifMixin

  FILE_EXTENSIONS = %w{jpeg jpg 3fr ari arw bay cap cr2 crw dcr dcs dng drf eip erf fff iiq k25 kdc mef mos mrw nef nrw orf pef ptx pxn r3d raf raw rw2 rwl rwz sr2 srf srw x3f}

  def magick
    MicroMagick::Convert.new(pathname.to_s)
  end

  def captured_at
    exif[:date_time_original] || exif[:create_date] || super
  end

  def sha1
    # We can't/shouldn't use the exif thumbprint, because
    # if they change how the image looks, the image caches should be rebuilt.
    pathname.sha1
  end

  def short_sha1
    sha1.first(8)
  end

  def canonical_name
    timestamp = captured_at.strftime("%Y%m%d")
    "#{timestamp}-#{short_sha1}"
  end

  def previews_path_for_captured_at
    (Setting.previews_root + ymd_dirs).ensure_directory
  end

  def ymd_dirs
    captured_at.strftime("%Y/%m/%d")
  end

  def cache_path_for_size(width, height, suffix = 'jpg')
    previews_path_for_captured_at + "#{canonical_name}_#{width}x#{height}.#{suffix}"
  end

  # @abstract Returns path to thumbnail
  # @param [Symbol] :size -- requested thumbnail size, options: :large, :medium, :small
  def thumbnail(size)
    cache_path_for_size(*Setting.thumbnail_dimension[size].split('x'))
  end

end
