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

  # Resize dimensions:
  #Square
  #  (75 x 75)
  #Thumbnail
  #(100 x 80)
  #Small
  #(240 x 192)
  #Medium 500
  #(500 x 399)
  #Medium 640
  #(640 x 511)
  #Large
  #(1024 x 818)
  #Original
  #(2634 x 2105)

end
