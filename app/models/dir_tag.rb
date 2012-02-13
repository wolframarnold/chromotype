class DirTag < Tag

  def self.root_name
    "file"
  end

  def self.process(asset)
    path = asset.pathname.parent.path_array
    tag = named_root.find_or_create_by_path path
    asset.add_tag(tag)
  end

  def pathname
    Pathname.new ancestry_path
  end

end
