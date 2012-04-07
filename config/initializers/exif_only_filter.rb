class Findler::Filters
  def self.exif_only(children)
    child_dirs = children.select{|ea|ea.directory?}
    child_files = children.select{|ea|ea.file?}
    files_with_exif = ExifMixin.exif_results(*child_files).keys
    files_with_exif + child_dirs
  end
end