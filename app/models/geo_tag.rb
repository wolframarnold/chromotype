require 'geonames'

class GeoTag < Tag
  def self.root_name
    "where"
  end

  def self.visit_asset(exif_asset)
    # todo: short-circuit if we already have geo tags
    e = exif_asset.exif
    if tag = tag_for_lat_lon(e[:gps_latitude], e[:gps_longitude])
      exif_asset.add_tag tag
    end
  end

  def self.tag_for_lat_lon(lat, lon)
    return nil if lat.nil? || lon.nil?
    places_nearby = Geonames::WebService.find_nearby_place_name(lat, lon) || []
    nearest = places_nearby.first
    return nil if nearest.nil? || nearest.geoname_id.to_i == 0
    places = Geonames::WebService.hierarchy(nearest.geoname_id)
    return nil if places.empty?
    named_root.find_or_create_by_path(places.collect { |ea| ea.name })
  end
end
