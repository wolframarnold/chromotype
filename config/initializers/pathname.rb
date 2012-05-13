class String
  def to_pathname
    Pathname.new(self)
  end
end

class Pathname

  def to_pathname
    self
  end

  def sha
    Digest::SHA1.file(to_s).hexdigest
  end

  # Returns the current path, split into an array.
  # Pathname.new("/a/b/c").path_array = ["a", "b", "c"]
  def path_array
    a = []
    each_filename{|ea|a << ea}
    a
  end

  def ensure_directory
    self.tap { |d| d.mkpath }
  end

  # returns either nil (if !#exists?), or an array of Pathname instances
  # whose last element is the end of the symlink chain
  def follow_redirects
    return nil unless self.exist?
    absolutepath.linkpath
  end

  # Like #realpath, but doesn't resolve symlinks.
  def absolutepath
    if absolute?
      self
    elsif to_s == "."
      realpath
    else
      parent.absolutepath + self.basename
    end
  end

  # Adds support for relative symlink pointers
  def readlink_to_pathname
    rl = readlink
    rl = parent + rl if rl.relative?
    rl
  end

  def linkpath(visited_paths = [])
    path = self.cleanpath
    return visited_paths if visited_paths.include? path # no circles
    visited_paths << path

    if symlink?
      readlink_to_pathname.linkpath(visited_paths)
    else
      visited_paths
    end
  end
end

