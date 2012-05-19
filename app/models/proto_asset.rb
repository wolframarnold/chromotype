class ProtoAsset

  include ExifMixin

  def initialize(uri)
    @uri = uri
  end

  def pathname
    self.paths && self.paths.last
  end

  def thumbprints
    @thumbprints ||= [ShaThumbprint, ExifAssetThumbprint].
      collect_hash(ActiveSupport::OrderedHash.new) do |klass|
      t = klass.thumbprint(pathname, exif_result)
      {klass => t} if t
    end
  end

  def paths
    @paths ||= begin
      pathname = @uri.to_pathname
      paths = pathname.follow_redirects
      if paths.nil?
        # the file has been deleted, so mark the assets accordingly
        Asset.with_filename(pathname.to_s).each { |ea| ea.sanity_check }
        nil
      else
        paths
      end
    end
  end

  def paths_to_s
    paths.collect { |ea| ea.to_s }.join(", ")
  end

  def find_or_initialize_asset
    if pathname.nil?
      # pathname will be nil if the file !exists
      simple_pathname = @uri.to_pathname
      if simple_pathname
        Asset.with_filename(simple_pathname).each { |ea| ea.sanity_check! }
      end
      return nil
    end

    asset = find_by_filename || find_by_thumbprint

    if exif? && self.image_pixels < Settings.minimum_image_pixels
      asset.delete! if asset
      return nil
    end

    asset ||= ExifAsset.new
    asset.lost_at = nil # we've found it!
    paths.each { |ea| asset.add_pathname ea }
    thumbprints.values.each { |ea| asset.add_thumbprint(ea) }

    # TODO: find all the other assets with a common thumbprint,
    # determine which is the "original" and which are the "derivatives"
    asset
  end

  def find_by_filename
    assets = Asset.with_any_filename(paths)
    if assets.size > 1
      assets.each { |ea| ea.sanity_check! }
    end
    assets.first
  end

  def find_by_thumbprint
    thumbprints.values.each do |t|
      a = Asset.with_thumbprint(t).first
      return a unless a.nil?
    end
    nil
  end
end
