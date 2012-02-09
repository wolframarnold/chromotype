class FileAsset < Asset

  def self.asset_for_file(filename, allowable_extensions = nil)
    paths = Pathname.new(filename).follow_redirects
    if paths.nil?
      # the file has been deleted, so mark the assets accordingly
      with_filename(filename).each { |ea| ea.deleted! }
      return true
    end

    if allowable_extensions
      path = paths.last
      suffix = path.extname.strip_prefix(".")
      return false unless FILE_EXTENSIONS.include? suffix
    end

    # first adopt the asset if there is one...
    assets = with_any_filename(paths)
    if assets.size > 1
      paths_to_s = paths.collect { |ea| ea.to_s }
      raise StandardError.new("Multiple assets found with paths: " + paths_to_s)
    end

    asset = assets.first || self.new
    paths.each { |ea| asset.uri = ea.to_uri }
    asset
  end
end
