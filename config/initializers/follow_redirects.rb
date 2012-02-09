class Pathname

  # returns either nil (if !#exists?), or an array of Pathname instances
  # whose last element is the end of the symlink chain
  def follow_redirects
    return nil unless self.exist?
    if absolute?
      self
    else
      absolutepath
    end.linkpath
  end

  # Like #realpath, but doesn't resolve symlinks.
  def absolutepath
    return self if absolute?
    parent.realpath + basename
  end

  # Adds support for relative symlink pointers
  def readlink_to_pathname
    rl = readlink
    rl = parent + rl if rl.relative?
    rl
  end

  def linkpath visited_paths = []
    path = self.cleanpath
    return visited_paths if visited_paths.include? path # no circles
    visited_paths << path

    if symlink?
      readlink_to_pathname.linkpath(visited_paths)
    else
      visited_paths
    end
  end

  protected :linkpath

end

