class AssetProcessor

  # "Visitors" are sent #visit_asset when assets are imported.
  VISITORS = [CameraTag,
    DateTag,
    DirTag,
    FaceTag,
    GeoTag,
    SeasonTag
  ]

  # "Thumbprinters" take a URI and extract a smallish string which can be used to match the asset with a duplicate file.

  def self.for_directory(directory)
    f = Findler.new directory
    f.append_extensions ExifAsset.FILE_EXTENSIONS
    f.case_insensitive!
    new(f.iterator)
  end

  def initialize(iterator)
    @iterator = iterator
  end

  def process_next
    process(iterator.next)
  end

  def process(pathname)
    pa = ProtoAsset.new(pathname)
    asset = pa.find_or_initialize_asset
    if asset
      asset.save!
      visit_asset(asset)
      asset
    end
  end

  def visit_asset(asset)
    VISITORS.each { |v| v.visit_asset(asset) }
  end
end


