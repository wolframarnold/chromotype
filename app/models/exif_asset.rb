class ExifAsset < Asset

  FILE_EXTENSIONS = %w{jpeg jpg 3fr ari arw bay cap cr2 crw dcr dcs dng drf eip erf fff iiq k25 kdc mef mos mrw nef nrw orf pef ptx pxn r3d raf raw rw2 rwl rwz sr2 srf srw x3f}

  def magick
    @magick ||= MiniMagick::Image.open self.uri
  end

  def captured_at
    exif[:date_time_original] || super
  end

  include Exiffed

  # Resize dimensions:
  #Square
  #  (75 x 75)
  #Thumbnail
  #(100 x 80)
  #Small
  #()
  #Medium 500
  #(400 x 400)
  #Medium 640
  #(800x800)
  #Large
  #(1200x1200)
  #Original
  #(2634 x 2105)

end
