class Findler::Filters
  def self.skip_exclusion_patterns(children)
    children.select { |ea| ea.basename.to_s !~ Setting.exclusion_regexp }
  end

  def self.with_minimum_resolution(children)
    child_dirs, child_files = children.partition { |ea| ea.directory? }
    big_enough = child_files.select do |ea|
      d = Dimensions.dimensions(ea.to_s)
      d && (d.first * d.last) >= Setting.minimum_image_pixels
    end
    big_enough + child_dirs
  end

  def self.exif_only(children)
    child_dirs, child_files = children.partition { |ea| ea.directory? }
    to_s_to_path = child_files.collect_hash { |ea| {ea.to_s => ea} }
    filenames_with_exif = ExifMixin.exif_results(*child_files).keys
    pathnames_with_exif = filenames_with_exif.map { |ea| to_s_to_path[ea] }
    pathnames_with_exif + child_dirs
  end
end
