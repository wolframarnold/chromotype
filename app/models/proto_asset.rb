# This class tries to find the best matching asset,
# or create a new one if this asset hasn't been imported yet

class ProtoAsset

  # "Fingerprinters" take a URI and extract a smallish string
  # which can be used to match the asset with a duplicate file.
  FINGERPRINTERS = [ShaFingerprint, ExifAssetFingerprint]

  # "Visitors" are sent #visit_asset when assets are imported.
  VISITORS = [CameraTag, DateTag, DirTag, FaceTag, GeoTag, SeasonTag, ImageResizer]

  include ExifMixin

  def initialize(uri, fingerprinters = FINGERPRINTERS, visitors = VISITORS)
    @uri = uri
    @fingerprinters = fingerprinters
    @visitors = visitors
  end

  def process
    p = @uri.pathname
    raise NotImplementedError if p.nil? # not a file URL

    unless p.exist?
      Asset.with_filename(p).each { |ea| ea.sanity_check! }
      return
    end

    # OK, now we now may have symlink chains to traverse:
    # are we already up to date?
    AssetUri.find_by_filename(p)
    return if pa.asset_is_up_to_date
    pa.find_or_create_asset.tap do |asset|
      VISITORS.each { |v| v.visit_asset(asset) } if asset
    end
  else
  end

end

def pathname
  @pathname ||= self.paths && self.paths.last
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

def thumbprints
  @thumbprints ||= begin
    return nil if paths.nil?
    [*FINGERPRINTERS].collect_hash(ActiveSupport::OrderedHash.new) do |klass|
      t = klass.thumbprint(pathname, exif_result)
      {klass => t} if t
    end
  end
end

def paths_to_s
  paths.collect { |ea| ea.to_s }.join(", ")
end

def asset_uri

  def asset
    @asset ||= begin
      if pathname.nil?
        # The pathname doesn't exist. Clean up assets that reference it:
        simple_pathname = @uri.to_pathname
        if simple_pathname
          Asset.with_filename(simple_pathname).each { |ea| ea.sanity_check! }
        end
        return nil
      end
      asset_uris = AssetUri.with_filename(pathname).find_by_mtime_and_filesize(pathname.mtime, pathname.size)
      if asset_uris.size == 1
        asset_uri = asset_uris.first
        if asset_uri.

          end
        end
      end

      def find_or_create_asset


        asset = find_by_filename || find_by_thumbprint

        if exif? && self.image_pixels < Settings.minimum_image_pixels
          asset.delete! if asset
          return nil
        end

        asset ||= ExifAsset.new
        asset.lost_at = nil # we've found it!
        paths.each { |ea| asset.add_pathname ea }
        asset.save!
        thumbprints.values.each { |ea| asset.add_thumbprint(ea) }
        asset.move_to_library
        asset
      end

      def find_by_filename
        assets = Asset.with_any_filename(paths)

        # TODO: what if the asset at that filename has changed?

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
