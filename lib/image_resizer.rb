class ImageResizer
  def self.visit_asset(exif_asset)
    m = exif_asset.magick
    #m.strip # remove exif headers
    #m.quality(85) #TODO: needed?
    resizes = Settings.resizes.sort_by { |a| a.to_i }.reverse
    files = resizes.collect do |size|
      # The '>' prevents enlargements.
      m.resize(size + ">")

      w, h = size.split("x")
      p = exif_asset.cache_path_for_size(w.to_i, h.to_i, "jpg")
      p.parent.mkpath
      m.format("jpg")
      m.write(p)
      p
    end

    # For the cropped square, load the 2nd-to-last and crop (to handle panoramas properly)
    m = MiniMagick::Image.open files[-3]
    min = [m.height, m.width].min
    m.gravity("Center")
    m.crop("#{min}x#{min}")
    Settings.square_crops.each do |size|
      m.resize(size)
      w, h = size.split("x")
      m.write(exif_asset.cache_path_for_size(w.to_i, h.to_i))
    end
  end
end
