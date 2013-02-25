class FaceTag < Tag
  def self.root_name
    "who"
  end

  def self.visit_asset(exif_asset)
    types = exif_asset.exif[:region_type]
    names = exif_asset.exif[:region_name]

    return if types.nil? || names.nil?

    faces = names.zip(types).collect{|name, type| name if type.to_s.downcase == "face" }.compact

    faces.each do |face|
      face_path = Settings.split_face_names ? face.split : [face]
      face_path.reverse! if Settings.reverse_face_paths
      exif_asset.add_tag(named_root.find_or_create_by_path(face_path), self)
    end
  end
end
