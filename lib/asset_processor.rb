require 'benchmark'

class AssetProcessor

  # "Thumbprinters" take a URI and extract a smallish string
  # which can be used to match the asset with a duplicate file.
  # (see ProtoAsset)

  # "Visitors" are sent #visit_asset when assets are imported.
  VISITORS = [
    CameraTag,
    DateTag,
    DirTag,
    FaceTag,
    GeoTag,
    SeasonTag,
    ImageResizer
  ]

  def self.for_directory(directory)
    f = Findler.new directory
    f.append_extensions ExifAsset.FILE_EXTENSIONS
    f.case_insensitive!
    f.exclude_hidden!
    f.add_filters :skip_exclusion_patterns, :exif_only
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
      if Settings.move_to_library
        # Are we the only one?
        others = pa.assets_with_any_thumbprint.sort_by(:mtime)
        winner = others.pop # most-recently-touched wins
        winner.move_to_originals
        winner.original_asset = nil
        winner.save!
        others.each do |ea|
          ea.move_to_derivatives
          ea.original_asset = winner
          ea.save!
        end
      end
      asset.save!
      visit_asset(asset)
      asset
    end
  end

  def visit_asset(asset)
    VISITORS.each { |v| v.visit_asset(asset) }
  end
end


