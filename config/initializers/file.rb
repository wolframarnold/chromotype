class File
  def self.follow_redirects(path, options = {})
    path = Pathname.new(path) unless path.is_a? Pathname
    return nil unless path.exist?
    path = path.cleanpath
    options[:paths] ||= []

    # gah, cycleage
    return options[:paths] if (options[:paths].include? path.to_s)

    options[:paths] << path.to_s

    # if link, follow.
    if path.symlink?
      follow_redirects(path.readlink_to_pathname, options)
    else
      options[:paths]
    end
  end
end

class Pathname
  # Adds support for relative symlink pointers
  def readlink_to_pathname
    rl = readlink
    rl = parent + rl if rl.relative?
    rl
  end
end

