class CameraTag < Tag

  def self.root_name
    "with"
  end

  def self.visit_asset(exif_asset)
    # todo: short-circuit if we already have camera tags
    exif = exif_asset.exif
    return if exif.nil?
    a = [exif[:make], exif[:model]].compact # Not all photos have either
    return if a.empty?
    exif_asset.add_tag(named_root.find_or_create_by_path(a))
  end
end
