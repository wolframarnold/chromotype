# This class tries to find the best matching asset,
# or create a new one if this asset hasn't been imported yet

class ProtoAsset

  # "URNers" take a URL and extract a URN
  # which can be used to match the asset with a duplicate file.
  DEFAULT_URNERS = [URN::FsAttrs, URN::Sha1, URN::ExifSha] # in order of expense

  # "Visitors" are sent #visit_asset when assets are imported.
  DEFAULT_VISITORS = [CameraTag, DateTag, DirTag, FaceTag, GeoTag, SeasonTag, ImageResizer]

  include ExifMixin

  def initialize(url, urners = DEFAULT_URNERS, visitors = DEFAULT_VISITORS)
    @url = url
    @urners = urners
    @visitors = visitors
  end

  def process
    # TODO: support non-file URLs:
    raise NotImplementedError if pathname.nil? # not a file URL

    find_or_create_asset.tap do |asset|
      @visitors.each { |v| v.visit_asset(asset) } if asset
    end
  end

  def pathname
    @pathname ||= self.paths && self.paths.last
  end

  def paths
    @paths ||= begin
      pathname = @url.to_pathname
      paths = pathname.follow_redirects
      if paths.nil?
        # the file has been deleted, so mark the assets accordingly
        Asset.with_filename(pathname.to_s).each { |ea| ea.sanity_check! }
        nil
      else
        paths
      end
    end
  end

  def urns
    @urns ||= begin
      return nil if paths.nil?
      @urners.collect_hash(ActiveSupport::OrderedHash.new) do |klass|
        t = klass.urn(pathname, exif_result)
        {klass => t} if t
      end
    end
  end

  def paths_to_s
    paths.collect { |ea| ea.to_s }.join(", ")
  end

  def find_or_create_asset
    @asset ||= begin
      return nil if pathname.nil?

      # Find the first asset that matches a URN (they're in order of expense)
      asset = @urners.each do |urner|
        urn = urner.urn_for_pathname(pathname)
        assets = Asset.find_by_urn(urn)
        rails.logger.warn ("multiple assets match #{urn}") if assets.size > 1
        break assets.first unless assets.empty?
      end
      asset ||= Asset.create(:basename => pathname.basename)
      asset_url = asset.asset_urls.find_or_create_by_url(url)
      @urners.each do |urner|
        urn = urner.urn_for_pathname(pathname)
        asset_url.asset_urns.find_or_create_by_urn(urn)
      end
      asset
    end
  end
end

