class DirTag < Tag
  def self.for_file(file)
    p = Pathname.new(file)
    p = p.parent unless p.directory?
    find_or_create_by_path p.realpath.each_filename.to_a
  end

  def path
    Pathname.new ancestry_path
  end

  def priority
    # The first 100 priorities are used for user-time background jobs.
    100 + Time.now.to_i - File.mtime(file_name).to_i
  end
end