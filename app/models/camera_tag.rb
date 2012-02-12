class CameraTag < Tag

  def self.root_name
    "with"
  end

  def self.add_camera_tag(exif_asset)
    # todo: short-circuit if we already have camera tags
    exif = exif_asset.try(:exif)
    return if exif.nil?
    a = [exif.make, exif.model].compact
    return if a.empty?
    exif_asset.add_tag named_root.find_or_create_by_path(a)
  end

  Asset.add_processor CameraTag.method("add_camera_tag")

end
