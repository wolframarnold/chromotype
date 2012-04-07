class Findler::Filters
  def self.exif_only(children)
    child_files = children.select{|ea|ea.file?}
    child_dirs = children.select{|ea|ea.directory?}
    e = Exiftoolr.new(child_files)
    e.files_with_results + child_dirs
  end
end