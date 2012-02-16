require 'geonames'

class FaceTag < Tag

  def self.root_name
    "who"
  end

  def self.process(exif_asset)
    # todo: short-circuit if we already have face tags
    types = exif_asset.exif[:region_type]
    names = exif_asset.exif[:region_name]
    return if types.nil? || names.nil?
    faces = []
    types.each_with_index{|ea, i| faces << names[i] if ea.downcase == "face" }
    faces.collect{ | ea | exif_asset.add_tag(named_root.find_or_create_by_name(ea))}
  end
end
