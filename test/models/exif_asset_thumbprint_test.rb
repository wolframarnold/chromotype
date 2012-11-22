require "minitest_helper"

def exifa(path)
  ExifAssetFingerprint.exif_thumbprint_array("test/images/#{path}")
end

describe ExifAssetFingerprint do
  it "should find a resized asset from Preview.app as equivalent" do
    exifa("Canon 20D.jpg").must_equal(exifa("Canon 20D-small.jpg"))
  end

  it "should find a recolored asset from Picasa as equivalent" do
    a = exifa("IMG_2452.jpg")
    a.wont_be_empty
    a.must_equal(exifa("IMG_2452_picasa.jpg"))
  end
end
