class ProtoAsset

  include Exiffed
  THUMBPRINTERS = [ShaThumbprint, ExifAssetThumbprint]

  def initialize(uri)
    @uri = uri
  end

  def pathname
    self.paths && self.paths.last
  end

  def paths
    @paths ||= begin
      pathname = @uri.to_pathname
      paths = pathname.follow_redirects
      if paths.nil?
        # the file has been deleted, so mark the assets accordingly
        Asset.with_filename(pathname.to_s).each { |ea| ea.delete! }
        nil
      else
        paths
      end
    end
  end

  def paths_to_s
    paths.collect { |ea| ea.to_s }.join(", ")
  end

  def thumbprints
    @thumbprints ||= THUMBPRINTERS.collect { |t| t.thumbprint(pathname, exif_result) }
  end

  def find_or_initialize_asset
    return if pathname.nil?
    asset = find_by_filename || find_by_thumbprint || ExifAsset.new
    # Do we even want this asset?
    return nil if exif? && self.image_pixels < Settings.minimum_image_pixels

    paths.each { |p| asset.uri = p.to_uri }
    thumbprints.each { |t| asset.asset_thumbprints.build(
      :type => t.type,
        :thumbprint => t.thumbprint
    ) }
    # no need to re-read the exif headers!
    asset.exiftoolr = self.exiftoolr
    asset
  end

  def find_by_filename
    assets = Asset.with_any_filename(paths)
    if assets.size > 1
      raise ArgumentError, "Multiple assets found for paths: #{paths_to_s}"
    end
    assets.first
  end

  def find_by_thumbprint
    thumbprints.each do |t|
      a = Asset.with_thumbprint(t).first
      return a unless a.nil?
    end
    nil
  end

end
