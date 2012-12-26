module URI
  class File < Generic
    def self.for_file(path)
      new("file", nil, "", nil, nil, URI.escape(path), nil, nil, nil)
    end

    def initialize(*args)
      # Make sure host is "", not nil, so to_s always starts with file://
      args[2] ||= ""
      super(*args)
    end

    def file_path
      URI.unescape(path)
    end

    def to_pathname
      Pathname.new(file_path)
    end

    def file
      ::File.new(file_path)
    end

    def read
      file.read
    end
  end
  @@schemes['FILE'] = File
end