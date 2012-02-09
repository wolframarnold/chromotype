class DirTag < Tag
  def self.for_pathname(p)
    p = p.parent unless p.directory?
    find_or_create_by_path p.each_filename.to_a
  end

  def path
    Pathname.new ancestry_path
  end
end
