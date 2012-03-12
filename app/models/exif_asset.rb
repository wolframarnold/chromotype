class ExifAsset < Asset

  FILE_EXTENSIONS = %w{jpeg jpg 3fr ari arw bay cap cr2 crw dcr dcs dng drf eip erf fff iiq k25 kdc mef mos mrw nef nrw orf pef ptx pxn r3d raf raw rw2 rwl rwz sr2 srf srw x3f}

  def magick
    MicroMagick::Convert.new(pathname.to_s)
  end

  def captured_at
    exif[:date_time_original] || super
  end

  include ExifMixin

  def sha
    # We can't/shouldn't use the exif thumbprint, because if they change how the image looks, the caches should be redone.
    @sha ||= Digest::SHA1.hexdigest(pathname.to_s)
  end

  def short_sha
    @short_sha ||= sha.first(8)
  end

  def canonical_name
    timestamp = captured_at.strftime("%Y%m%d_%H:%M")
    "#{timestamp}-#{short_sha}"
  end

  def cache_dir
    @cache_dir ||= begin
      p = Settings.cache_dir.to_pathname + captured_at.strftime("%Y/%m")
      p.mkpath unless p.directory?
      p
    end
  end

  def cache_path_for_size(width, height, suffix = 'jpg')
    cache_dir + "#{canonical_name}_#{width}x#{height}.#{suffix}"
  end
end
