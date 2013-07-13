class ImageResizer
  def self.visit_asset(exif_asset)
    p = exif_asset.pathname.to_s
    out = [p, p] # so [-2] works
    Setting.resizes.each do |size|
      # Use the second-to-last as the resize source to prevent aliasing:
      m = MicroMagick::Convert.new(out[-2])
      m.strip # remove exif headers
      m.resize(size + ">") # The '>' prevents enlargements.
      w, h = size.split("x")
      f = exif_asset.cache_path_for_size(w.to_i, h.to_i).to_s
      out << f
      m.write(f)
    end

    # For the cropped square, load the crop source (to handle panoramas properly)
    biggest_square = Setting.square_crop_sizes.first
    src = out.reverse.find do |f|
      Dimensions.dimensions(f).min > biggest_square
    end

    src ||= out.first
    m = MicroMagick::Convert.new(src)
    Setting.square_crop_sizes.each do |w|
      m.strip
      m.square_crop
      m.resize("#{w}x#{w}")
      f = exif_asset.cache_path_for_size(w.to_i, w.to_i).to_s
      m.write(f)
    end
  end
end
