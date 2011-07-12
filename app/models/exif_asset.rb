class ExifAsset < FileAsset
  class << self
    def import file
# TODO
    end

    def can_import? file
      file = Pathname.as_path file
      ext = file.extname
      file.to_s
      # TODO
    end
  end
end
